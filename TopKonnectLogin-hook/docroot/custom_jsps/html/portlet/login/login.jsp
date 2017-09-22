<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletURL"%>

<%@page import="com.liferay.portal.kernel.servlet.SessionMessages"%>
<%@page import="com.liferay.portal.kernel.dao.orm.Session"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="com.liferay.portal.model.User"%>
<%@page import="com.liferay.portal.service.ImageLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.Image"%>

<%@ include file="/html/portlet/login/init.jsp"%>

<portlet:defineObjects />
 <head>
<link rel="stylesheet" type="text/css" href="/html/portlet/login/login-portlet.css">

<script>
function myFunction()
{
	document.getElementById("mycontent").style.display="none";
	document.getElementById("status").style.display="none";
	document.getElementById("status1").style.display="none";
	document.getElementById('signupli').setAttribute("class", "");
	document.getElementById('signinli').setAttribute("class", "active");
	document.getElementById("rjus").style.display="none";
	document.getElementById("portlet-title-text").style.color="white";
	$("#signupli").attr("class","");
	$("#signinli").attr("class","active");
	
}


</script>
<style>
.portlet-msg-error,.lfr-message-error {
	background-color: gray;
	background-image: none;
	border-color: black;
	padding: 0px;
	margin: 0px;
}

.portlet-msg,.portlet-msg-info,.portlet-msg-help,.lfr-message-help,.portlet-msg-progress,.lfr-message-progress,.lfr-message-info,.portlet-msg-error,.lfr-message-error,.portlet-msg-alert,.lfr-message-alert,.portlet-msg-success,.lfr-message-success
	{
	margin: 0px;
	margin-bottom: 2px;
	width: 280px;
}
</style>
</head>
<body onload="myFunction()" style="overflow-x: none;">
 <!-- <liferay-ui:error key="pwd"/> -->
	<c:choose>
		<c:when test="<%= themeDisplay.isSignedIn() %>">

			<%
		String signedInAs = HtmlUtil.escape(user.getFullName());
		if (themeDisplay.isShowMyAccountIcon()) {
			signedInAs = "<a href=\"" + HtmlUtil.escape(themeDisplay.getURLMyAccount().toString()) + "\">" + signedInAs + "</a>";
		}
		%>


			<p
				style="float: right; width: 100%; font-size: 16px; margin-left: 100px; color: white; margin-top: 5px;">
				<img src=<%=HtmlUtil.escape(user.getPortraitURL(themeDisplay))%>
					style="margin-right: 10px; width: 50px; height: 50px; float: left;" />
				Welcome<br />
				<%=signedInAs %>
			</p>
			<%-- <%= LanguageUtil.format(pageContext, "you-are-signed-in-as-x", signedInAs, false) %> --%>
		</c:when>
		<c:otherwise>

			<%
		//String redirect = ParamUtil.getString(request, "redirect");
		String redirect = "/web/guest/businesshome";
		String login = LoginUtil.getLogin(request, "login", company);
		String password = StringPool.BLANK;
		boolean rememberMe = ParamUtil.getBoolean(request, "rememberMe");

		if (Validator.isNull(authType)) {
			authType = company.getAuthType();
		}
		%>

			<portlet:actionURL
				secure="<%= PropsValues.COMPANY_SECURITY_AUTH_REQUIRES_HTTPS || request.isSecure() %>"
				var="loginURL">
				<portlet:param name="saveLastPath" value="0" />
				<portlet:param name="struts_action" value="/login/login" />
				<portlet:param name="doActionAfterLogin"
					value="<%= portletName.equals(PortletKeys.FAST_LOGIN) ? Boolean.TRUE.toString() : Boolean.FALSE.toString() %>" />
			</portlet:actionURL>


			

			<aui:form action="<%= loginURL %>"
				autocomplete='<%= PropsValues.COMPANY_SECURITY_LOGIN_FORM_AUTOCOMPLETE ? "on" : "off" %>'
				method="post" name="fm" role="form" style="width:30%">

			<span style="font-size: 17.6px; font-weight: bold; left: 43%; margin-left: 15%; position: relative; right: 0; top:15%; z-index: 99999;color:#00708c">Or Sign In with</span>
				<aui:input name="redirect" type="hidden" value="<%= redirect %>" />

				<c:choose>
					<c:when
						test='<%= SessionMessages.contains(request, "user_added") %>'>

						<%
							String userEmailAddress = (String)SessionMessages.get(request, "user_added");
							String userPassword = (String)SessionMessages.get(request, "user_added_password");
						%>

						<div class="portlet-msg-success">
							<c:choose>
								<c:when
									test="<%= company.isStrangersVerify() || Validator.isNull(userPassword) %>">
									<%= LanguageUtil.get(pageContext, "thank-you-for-creating-an-account") %>

									<c:if test="<%= company.isStrangersVerify() %>">
										<%= LanguageUtil.format(pageContext, "your-email-verification-code-has-been-sent-to-x", userEmailAddress) %>
									</c:if>
								</c:when>
								<c:otherwise>
									<%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account.-your-password-is-x", userPassword, false) %>
								</c:otherwise>
							</c:choose>

							<c:if
								test="<%= PrefsPropsUtil.getBoolean(company.getCompanyId(), PropsKeys.ADMIN_EMAIL_USER_ADDED_ENABLED) %>">
								<%= LanguageUtil.format(pageContext, "your-password-has-been-sent-to-x", userEmailAddress) %>
							</c:if>
						</div>
					</c:when>
					<c:when
						test='<%= SessionMessages.contains(request, "user_pending") %>'>

						<%
					String userEmailAddress = (String)SessionMessages.get(request, "user_pending");
					%>

						<div class="portlet-msg-success">
							<%= LanguageUtil.format(pageContext, "thank-you-for-creating-an-account.-you-will-be-notified-via-email-at-x-when-your-account-has-been-approved", userEmailAddress) %>
						</div>
					</c:when>
				</c:choose>







				<liferay-ui:error exception="<%= CompanyMaxUsersException.class %>"
					message="unable-to-login-because-the-maximum-number-of-users-has-been-reached" />
				<liferay-ui:error
					exception="<%= CookieNotSupportedException.class %>"
					message="authentication-failed-please-enable-browser-cookies" />
				<liferay-ui:error exception="<%= NoSuchUserException.class %>"
					message="authentication-failed" />
				<liferay-ui:error exception="<%= PasswordExpiredException.class %>"
					message="your-password-has-expired" />
				<liferay-ui:error exception="<%= UserEmailAddressException.class %>"
					message="authentication-failed" />
				<liferay-ui:error exception="<%= UserLockoutException.class %>"
					message="this-account-has-been-locked" />
				<liferay-ui:error exception="<%= UserPasswordException.class %>"
					message="authentication-failed" />
				<liferay-ui:error exception="<%= UserScreenNameException.class %>"
					message="authentication-failed" />
				</td>
				</tr>
				<liferay-ui:error exception="<%= UserScreenNameException.class %>"
					message="Oops! authentication-failed " />
				<aui:fieldset>

					<%
				String loginLabel = null;

				if (authType.equals(CompanyConstants.AUTH_TYPE_EA)) {
					loginLabel = "email-address";
				}
				else if (authType.equals(CompanyConstants.AUTH_TYPE_SN)) {
					loginLabel = "screen-name";
				}
				else if (authType.equals(CompanyConstants.AUTH_TYPE_ID)) {
					loginLabel = "id";
				}
				%>
				
					<!-- Custom Login Function -->
					<div class="row"
						style="width: 80%; margin-left: 5%; margin-right: 5%;">
						<div class="col-md-6">
						  
							<h4 style="font-weight: bold; width: 40%;">Log in Using
								email:</h4>
							<div class="form-group" style="margin-top: 10%;">
								<div class="input-group login-input">
									<strong><font
										style="font-size: 18px; color: gray; margin-bottom: 2px;">Email Id</font></strong><br> <input class="form-control"
										placeholder="Email Id" type="text" name="login"
										style="margin-top: 5%;">
								</div>
								<br>
								<div class="input-group login-input">
									<strong><font
										style="font-size: 18px; color: gray; margin-bottom: 2px;">Password</font></strong><br>
									<input class="form-control" placeholder="Password"
										type="password" name="password" style="margin-top: 5%;">
								</div>
								<div class="checkbox" style="margin-top: 5%;">
									<label> <input type="checkbox"
										checked="<%= rememberMe %>" name="rememberMe"><span
										style="margin-top: 5%;color:black;"> Remember me</span>
									</label>
								</div>
								<!-- <button type="submit" class="loginBtn" value="Login"
									style="width: 28%; color: black; font-weight: bold;">LOG
									IN</button> -->
									<button class="btn btn-primary" type="submit" style="width:36%"><i class="fa fa-user"></i>&nbsp;<span>LOG IN</span></button>
								<div class="clearfix"></div>
							</div>

						</div>
						<!-- <div class="col-md-6" style="border-left: 3px solid gray;">
							<h4 style="font-weight: bold; width: 40%;">Or,Log in with:</h4>
							<div class="form-group" style="margin-top: 28%;">
								<div class="input-group login-input" style="margin-top: 27.7%;">
									<a href="#"><img src="/html/portlet/login/ln2.jpg"
										width="85%" height="80%" /> </a>
								</div>
								<div class="input-group loginn-input">
									<a href="#"> <img width="40%" height="100%"
										src="/html/portlet/login/go4.png"
										style="margin-top: 14px; height: 39px; width: 170px;">
									</a>
								</div>

								<div class="input-group login-input"
									style="z-index: 9999; margin-top: 20%;">
									<strong> <span>Don't have an account? <a
											style="text-transform: none;"#">Join</a> Estimize
									</span></strong>
								</div>
							</div>
						</div> -->
					</div>
					<%-- <aui:input label="<%= loginLabel %>" name="login" showRequiredLabel="<%= false %>" type="text" value="<%= login %>">
					<aui:validator name="required" />
				</aui:input> --%>




					<%-- <aui:input name="password" showRequiredLabel="<%= false %>" type="password" value="<%= password %>">
					<aui:validator name="required" />
				</aui:input> --%>






					<span id="<portlet:namespace />passwordCapsLockSpan"
						style="display: none; color: red;"><liferay-ui:message
							key="caps-lock-is-on" /></span>
					<br />&nbsp;
				
				<%-- <c:if test="<%= company.isAutoLogin() && !PropsValues.SESSION_DISABLED %>">
					<aui:input checked="<%= rememberMe %>" name="rememberMe" type="checkbox" />
				</c:if> --%>
				</aui:fieldset>

				<!-- <aui:button-row>
				<aui:button type="submit" value="sign-in" />
			</aui:button-row> -->


			</aui:form>


			<liferay-util:include page="/html/portlet/login/navigation.jsp" />

			<c:if test="<%= windowState.equals(WindowState.MAXIMIZED) %>">
				<aui:script>
				Liferay.Util.focusFormField(document.<portlet:namespace />fm.<portlet:namespace />login);
			</aui:script>
			</c:if>

			<aui:script use="aui-base">
			var password = A.one('#<portlet:namespace />password');

			if (password) {
				password.on(
					'keypress',
					function(event) {
						Liferay.Util.showCapsLock(event, '<portlet:namespace />passwordCapsLockSpan');
					}
				);
			}
		</aui:script>
		</c:otherwise>
	</c:choose>
</body>