package com.liferay.samplestrutsaction.hook.action;

import java.rmi.ServerError;
import java.util.Date;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletConfig;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;

import com.db.model.Business;
import com.db.model.city;
import com.db.model.registeruser;
import com.db.service.BusinessLocalServiceUtil;
import com.db.service.cityLocalServiceUtil;
import com.db.service.registeruserLocalServiceUtil;
import com.liferay.counter.service.CounterLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.Criterion;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.DynamicQueryFactoryUtil;
import com.liferay.portal.kernel.dao.orm.RestrictionsFactoryUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.struts.BaseStrutsPortletAction;
import com.liferay.portal.kernel.struts.StrutsPortletAction;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.workflow.WorkflowConstants;
import com.liferay.portal.model.Company;
import com.liferay.portal.model.CompanyConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.service.ServiceContext;
import com.liferay.portal.service.ServiceContextFactory;
import com.liferay.portal.service.UserServiceUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portal.util.PropsValues;
import com.liferay.portal.util.WebKeys;
import com.liferay.portlet.login.action.CreateAccountAction;

public class CustomCreateAccount extends BaseStrutsPortletAction {
	
	@Override
	public void processAction(PortletConfig portletConfig,
			ActionRequest actionRequest, ActionResponse actionResponse)
			throws Exception {
		
		super.processAction(portletConfig, actionRequest, actionResponse);
		addUser(actionRequest, actionResponse);
	}
	
	@Override
	public String render(StrutsPortletAction originalStrutsPortletAction,
			PortletConfig portletConfig, RenderRequest renderRequest,
			RenderResponse renderResponse) throws Exception {
		// TODO Auto-generated method stub
		 return originalStrutsPortletAction.render(null, portletConfig, renderRequest, renderResponse);
	}
	
	protected void addUser(
			ActionRequest actionRequest, ActionResponse actionResponse)
					throws Exception {
		System.out.println("#####Custom Create Account####");

		HttpServletRequest request = PortalUtil.getHttpServletRequest(
				actionRequest);
		HttpSession session = request.getSession();

		ThemeDisplay themeDisplay = (ThemeDisplay)actionRequest.getAttribute(
				WebKeys.THEME_DISPLAY);

		Company company = themeDisplay.getCompany();

		boolean autoPassword = true;
		String password1 = null;
		String password2 = null;
		boolean autoScreenName = false;
		String screenName = ParamUtil.getString(actionRequest, "screenName");
		String emailAddress = ParamUtil.getString(
				actionRequest, "emailAddress");
		long facebookId = ParamUtil.getLong(actionRequest, "facebookId");
		String openId = ParamUtil.getString(actionRequest, "openId");
		String firstName = ParamUtil.getString(actionRequest, "firstName");
		String middleName ="";
		String lastName = ParamUtil.getString(actionRequest, "lastName");
		int prefixId = ParamUtil.getInteger(actionRequest, "prefixId");
		int suffixId = ParamUtil.getInteger(actionRequest, "suffixId");
		boolean male = Boolean.TRUE;
		int birthdayMonth =1;
		int birthdayDay = 1;
		int birthdayYear = 2014;
		String jobTitle = "";

		long[] groupIds = null;
		long[] organizationIds = null;
		long[] roleIds = null;
		long[] userGroupIds = null;
		boolean sendEmail = true;

		ServiceContext serviceContext = ServiceContextFactory.getInstance(
				User.class.getName(), actionRequest);

		//if (PropsValues.LOGIN_CREATE_ACCOUNT_ALLOW_CUSTOM_PASSWORD) {
			autoPassword = false;

			//password1 = ParamUtil.getString(actionRequest, "password1");
			//password2 = ParamUtil.getString(actionRequest, "password2");
			String tempPwd=RandomStringUtils.randomAlphanumeric(6);
			password1=tempPwd;
			password2=tempPwd;
		//}

		boolean openIdPending = false;

		Boolean openIdLoginPending = (Boolean)session.getAttribute(
				WebKeys.OPEN_ID_LOGIN_PENDING);

		if ((openIdLoginPending != null) &&
				(openIdLoginPending.booleanValue()) &&
				(Validator.isNotNull(openId))) {

			sendEmail = false;
			openIdPending = true;
		}

		User user = UserServiceUtil.addUserWithWorkflow(
				company.getCompanyId(), autoPassword, password1, password2,
				autoScreenName, screenName, emailAddress, facebookId, openId,
				themeDisplay.getLocale(), firstName, middleName, lastName, prefixId,
				suffixId, male, birthdayMonth, birthdayDay, birthdayYear, jobTitle,
				groupIds, organizationIds, roleIds, userGroupIds, sendEmail,
				serviceContext);

		//Custom Registration Entry
		registeruser registeruserObj=registeruserLocalServiceUtil.createregisteruser(user.getUserId());
		registeruserObj.setBusinessname(ParamUtil.getString(actionRequest, "businesshome"));
		registeruserObj.setContact(ParamUtil.getLong(actionRequest, "contact"));
		registeruserObj.setCountry(ParamUtil.getString(actionRequest, "country"));
		registeruserObj.setCity(ParamUtil.getString(actionRequest, "city"));
		registeruserObj.setIndustrytype(ParamUtil.getString(actionRequest, "industry"));
		registeruserObj.setPrimarybusiness(ParamUtil.getString(actionRequest, "primarybusiness"));
		registeruserObj.setPrimarypurpose(ParamUtil.getString(actionRequest, "primarypurpose"));
		registeruserLocalServiceUtil.addregisteruser(registeruserObj);
		//custom business entry
		Business business=BusinessLocalServiceUtil.createBusiness(user.getUserId());
		business.setCompanyId(company.getCompanyId());
		business.setUserId(user.getUserId());
		business.setUserName(screenName);
		business.setCreateDate(new Date());
		business.setModifiedDate(new Date());
		business.setBusinessName(ParamUtil.getString(actionRequest, "businesshome"));
		business.setBusinessCode(tempPwd);
		business.setCountry(ParamUtil.getString(actionRequest, "country"));
		business.setCity(ParamUtil.getString(actionRequest, "city"));
		business.setMobileNo(ParamUtil.getLong(actionRequest, "contact"));
		business.setWorkNo(0);
		business.setLink("");
		business.setBannerimg("");
		BusinessLocalServiceUtil.addBusiness(business);
		

		if (openIdPending) {
			session.setAttribute(
					WebKeys.OPEN_ID_LOGIN, new Long(user.getUserId()));

			session.removeAttribute(WebKeys.OPEN_ID_LOGIN_PENDING);
		}
		else {

			// Session messages
			if (user.getStatus() == WorkflowConstants.STATUS_APPROVED) {
				SessionMessages.add(
						request, "user_added", user.getEmailAddress());
				SessionMessages.add(
						request, "user_added_password",
						user.getPasswordUnencrypted());
			}
			else {
				SessionMessages.add(
						request, "user_pending", user.getEmailAddress());
			}
		}

		// Send redirect

		String login = null;

		if (company.getAuthType().equals(CompanyConstants.AUTH_TYPE_ID)) {
			login = String.valueOf(user.getUserId());
		}
		else if (company.getAuthType().equals(CompanyConstants.AUTH_TYPE_SN)) {
			login = user.getScreenName();
		}
		else {
			login = user.getEmailAddress();
		}
		SessionErrors.add(actionRequest,"pwd", tempPwd);
		actionResponse.sendRedirect("/customlogin");
		/*sendRedirect(
				actionRequest, actionResponse, themeDisplay, login,
				user.getPasswordUnencrypted());*/
	}
	
}
