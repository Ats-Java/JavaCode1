

<%@page import="java.util.Iterator"%>
<%@page import="com.liferay.portal.service.CountryServiceUtil"%>
<%@page import="com.liferay.portal.model.Country"%>
<%@page import="java.util.List"%>
<link rel="stylesheet" type="text/css"  href="/html/portlet/login/smart-forms.css">
<link rel="stylesheet" type="text/css"  href="/html/portlet/login/font-awesome.min.css">
<script type="text/javascript" src="/html/portlet/login/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/html/portlet/login/jquery.validate.js"></script>
<script type="text/javascript" src="/html/portlet/login/cascade.js"></script>
<%@ include file="/html/portlet/login/init.jsp"%>

<script>
	function myFunction() {
		document.getElementById("mycontent").style.display = "none";
		document.getElementById("status").style.display = "none";
		document.getElementById("status1").style.display = "none";
		$("#signupli").attr("class","active");
		$("#mytext").text("Or Sign Up with..");
		
	}
	$("#industry").change(function() {
		alert('hh');
		if($(this).data('options') == undefined){
		    /*Taking an array of all options-2 and kind of embedding it on the select1*/
		    $(this).data('options',$('#producttype option').clone());
		    } 
		var id = $(this).val();
		var options = $(this).data('options').filter('[value=' + id + ']');
		$('#producttype').html(options);
		});

</script>

 <body onload="myFunction()" style="overflow-x: none;">
	<%
		String redirect = ParamUtil.getString(request, "redirect");

		String openId = ParamUtil.getString(request, "openId");

		PasswordPolicy passwordPolicy = PasswordPolicyLocalServiceUtil
				.getDefaultPasswordPolicy(company.getCompanyId());

		Calendar birthday = CalendarFactoryUtil.getCalendar();

		birthday.set(Calendar.MONTH, Calendar.JANUARY);
		birthday.set(Calendar.DATE, 1);
		birthday.set(Calendar.YEAR, 1970);

		boolean male = ParamUtil.getBoolean(request, "male", true);
	%>

	<portlet:actionURL var="createAccoutURL">
		<portlet:param name="saveLastPath" value="0" />
		<portlet:param name="struts_action" value="/login/create_account" />
	</portlet:actionURL>
	
	<aui:form action="<%=createAccoutURL%>" method="post" name="fm">
		
		<span
			style="font-size: 20px; font-weight: bold; left: 0; margin-left: 10%; right: 0; z-index: 99999;;color:#00708c">Sign
			Up with email </span>
		
		
		<aui:input name="<%=Constants.CMD%>" type="hidden"
			value="<%=Constants.ADD%>" />
		<aui:input name="redirect" type="hidden" value="<%=redirect%>" />
		<aui:input name="openId" type="hidden" value="<%=openId%>" />

		<liferay-ui:error exception="<%=AddressCityException.class%>"
			message="please-enter-a-valid-city" />
		<liferay-ui:error exception="<%=AddressStreetException.class%>"
			message="please-enter-a-valid-street" />
		<liferay-ui:error exception="<%=AddressZipException.class%>"
			message="please-enter-a-valid-postal-code" />
		<liferay-ui:error exception="<%=CaptchaMaxChallengesException.class%>"
			message="maximum-number-of-captcha-attempts-exceeded" />
		<liferay-ui:error exception="<%=CaptchaTextException.class%>"
			message="text-verification-failed" />
		<liferay-ui:error exception="<%=CompanyMaxUsersException.class%>"
			message="unable-to-create-user-account-because-the-maximum-number-of-users-has-been-reached" />
		<liferay-ui:error exception="<%=ContactFirstNameException.class%>"
			message="please-enter-a-valid-first-name" />
		<liferay-ui:error exception="<%=ContactFullNameException.class%>"
			message="please-enter-a-valid-first-middle-and-last-name" />
		<liferay-ui:error exception="<%=ContactLastNameException.class%>"
			message="please-enter-a-valid-last-name" />
		<liferay-ui:error
			exception="<%=DuplicateUserEmailAddressException.class%>"
			message="the-email-address-you-requested-is-already-taken" />
		<liferay-ui:error exception="<%=DuplicateUserIdException.class%>"
			message="the-user-id-you-requested-is-already-taken" />
		<liferay-ui:error
			exception="<%=DuplicateUserScreenNameException.class%>"
			message="the-screen-name-you-requested-is-already-taken" />
		<liferay-ui:error exception="<%=EmailAddressException.class%>"
			message="please-enter-a-valid-email-address" />
		<liferay-ui:error exception="<%=NoSuchCountryException.class%>"
			message="please-select-a-country" />
		<liferay-ui:error exception="<%=NoSuchListTypeException.class%>"
			message="please-select-a-type" />
		<liferay-ui:error exception="<%=NoSuchRegionException.class%>"
			message="please-select-a-region" />
		<liferay-ui:error exception="<%=PhoneNumberException.class%>"
			message="please-enter-a-valid-phone-number" />
		<liferay-ui:error exception="<%=RequiredFieldException.class%>"
			message="please-fill-out-all-required-fields" />
		<liferay-ui:error
			exception="<%=ReservedUserEmailAddressException.class%>"
			message="the-email-address-you-requested-is-reserved" />
		<liferay-ui:error exception="<%=ReservedUserIdException.class%>"
			message="the-user-id-you-requested-is-reserved" />
		<liferay-ui:error
			exception="<%=ReservedUserScreenNameException.class%>"
			message="the-screen-name-you-requested-is-reserved" />
		<liferay-ui:error exception="<%=TermsOfUseException.class%>"
			message="you-must-agree-to-the-terms-of-use" />
		<liferay-ui:error exception="<%=UserEmailAddressException.class%>"
			message="please-enter-a-valid-email-address" />
		<liferay-ui:error exception="<%=UserIdException.class%>"
			message="please-enter-a-valid-user-id" />

		<liferay-ui:error exception="<%=UserPasswordException.class%>">

			<%
				UserPasswordException upe = (UserPasswordException) errorException;
			%>

			<c:if
				test="<%=upe.getType() == UserPasswordException.PASSWORD_CONTAINS_TRIVIAL_WORDS%>">
				<liferay-ui:message
					key="that-password-uses-common-words-please-enter-in-a-password-that-is-harder-to-guess-i-e-contains-a-mix-of-numbers-and-letters" />
			</c:if>

			<c:if
				test="<%=upe.getType() == UserPasswordException.PASSWORD_INVALID%>">
				<liferay-ui:message
					key="that-password-is-invalid-please-enter-in-a-different-password" />
			</c:if>

			<c:if
				test="<%=upe.getType() == UserPasswordException.PASSWORD_LENGTH%>">
				<%=LanguageUtil
								.format(pageContext,
										"that-password-is-too-short-or-too-long-please-make-sure-your-password-is-between-x-and-512-characters",
										String.valueOf(passwordPolicy
												.getMinLength()), false)%>
			</c:if>

			<c:if
				test="<%=upe.getType() == UserPasswordException.PASSWORD_TOO_TRIVIAL%>">
				<liferay-ui:message key="that-password-is-too-trivial" />
			</c:if>

			<c:if
				test="<%=upe.getType() == UserPasswordException.PASSWORDS_DO_NOT_MATCH%>">
				<liferay-ui:message
					key="the-passwords-you-entered-do-not-match-each-other-please-re-enter-your-password" />
			</c:if>
		</liferay-ui:error>

		<liferay-ui:error exception="<%=UserScreenNameException.class%>"
			message="please-enter-a-valid-screen-name" />
		<liferay-ui:error exception="<%=WebsiteURLException.class%>"
			message="please-enter-a-valid-url" />

		<c:if
			test='<%=SessionMessages.contains(request,
							"missingOpenIdUserInformation")%>'>
			<div class="portlet-msg-info">
				<liferay-ui:message
					key="you-have-successfully-authenticated-please-provide-the-following-required-information-to-access-the-portal" />
			</div>
		</c:if>
		
		
		<aui:fieldset>
			<aui:column>
			  
			    <label>First Name</label>
			    <input type="text" name="firstName" class="form-control" placeholder="First Name"/>
				<!-- <aui:input type="text" name="firstName" style="border-color:black;" /> -->
				<label>Last Name</label>
			    <input type="text" name="lastName" class="form-control" placeholder="Last Name"/>
				<%-- <aui:input type="text" name="lastName" style="border-color:black; ">
					<c:if
						test="<%=PrefsPropsUtil.getBoolean(
										company.getCompanyId(),
										PropsKeys.USERS_LAST_NAME_REQUIRED,
										PropsValues.USERS_LAST_NAME_REQUIRED)%>">
						<!-- <aui:validator name="required" /> -->
					</c:if>
				</aui:input> --%>

				<c:if
					test="<%=!PrefsPropsUtil.getBoolean(
									company.getCompanyId(),
									PropsKeys.USERS_SCREEN_NAME_ALWAYS_AUTOGENERATE)%>">
						<label>User Name</label>
			            <input type="text" name="screenName" class="form-control" placeholder="User Name"/>
						<!-- <aui:input type="text" name="screenName"
						label="UserName" style="border-color:black; " /> -->
				</c:if>

						<label>Email</label>
			            <input type="text" name="emailAddress" class="form-control" placeholder="Email Id"/>
					<!-- <aui:input type="text" name="emailAddress" style="border-color:black; ">
					 </aui:input> -->

						<label>Contact</label>
			            <input type="text" name="contact" class="form-control" placeholder="Contact No"/>

				<!-- <aui:input name="contact" label="Contact" type="text" style="border-color:black; ">
					
				</aui:input> -->


			</aui:column>

			<aui:column>
				<c:if
					test="<%=PropsValues.LOGIN_CREATE_ACCOUNT_ALLOW_CUSTOM_PASSWORD%>">
					<aui:input label="password" name="password1" size="30"
						type="password" value="" style="border-color:black; "/>

					<aui:input label="enter-again" name="password2" size="30"
						type="password" value="" style="border-color:black; ">
						<aui:validator name="equalTo">
						'#<portlet:namespace />password1'
					</aui:validator>
					</aui:input>
				</c:if>
				<label>Business Name</label>
			    <input type="text" name="businesshome" class="form-control" placeholder="Business Name"/>
				<!-- <aui:input label="Business Name" name="businesshome" type="text" style="border-color:black;" placeholder="Business Name"> 
					
				</aui:input>-->
				<label>Country</label>
				<select label="Country" name="country" class="form-control" id="simple_select">

					<option label="" value="">Select a country</option>
					
                          	<%
                          	
                          	 List<Country> list1=CountryServiceUtil.getCountries();
                             for(Country country:list1 ) {
                            	
                          	 %>
                          	 <option  value="<%=country.getCountryId()%>" class="<%=country.getCountryId()%>"><%=country.getName()%></option>
                          	 <%} %>
			
				</select>
				<%-- <aui:select label="Country" name="country"
					style=" width: 73%; height: 30px;border:2px solid black;" >

					<aui:option label="" value=""> Select a country</aui:option>
					
                          	<%
                          	 List<Country> list1=CountryServiceUtil.getCountries();
                             for(Country country:list1 ) {
                            	
                          	 %>
                          	 <aui:option  value="<%=country.getCountryId()%>"><%=country.getName()%></aui:option>
                          	 <%} %>
			
				</aui:select> --%>
				
				<label>City</label>
				<select name="city" class="form-control" id="simple_select_child">
					<option label="" value="">Select a City</option>
			
					 <option value="1" class="1">kelowna</option>
					<option value="2" class="1">Tofino</option>
					<option value="3" class="1">Vancouver</option>
					<option value="4" class="1">Victoria</option>
					<option value="5" class="1">Whistler</option>
					
					<option value="6 " class="2">Beijing</option>
					<option value="7" class="2">Shanghai</option>
					<option value="8" class="2">Chongqing</option>
					<option value="9" class="2">Wuhan</option>
					<option value="10" class="2">Shenyang</option>
					
					<option value="11 " class="3">Paris</option>
					<option value="12" class="3">Avignon</option>
					<option value="13 " class="3">Aix-les-Bains </option>
					<option value="14" class="3">Bordeaux</option>
					<option value="15" class="3">Camembert</option>
					
					<option value="16" class="20">Balkh</option>
					<option value="17" class="20">Bamiyan </option>
					<option value="18" class="20">Ghazni </option>
					<option value="19" class="20">Herat</option>
					<option value="20" class="20">Kabul</option>
					
					<option value="21" class="108">Bangalore</option>
					<option value="22" class="108">Bombay </option>
					<option value="23" class="108">Nagpur </option>
					<option value="24" class="108">Hyderabad</option>
					<option value="25" class="108">Delhi</option>
				</select>
				
				<script type="text/javascript" charset="utf-8">
					      $(document).ready(function() {
					         $('#simple_select').cascade();
					      });
			    </script> 
				<!-- <aui:input label="City" name="city"
					type="text" style="border-color:black;" placeholder="City"> 
				</aui:input> -->
				<!-- <aui:select label="Industry" name="industry"
					style=" width: 73%; height: 30px;border:2px solid black;">
							   <aui:option value="agriculture" class="agriculture">Agriculture</aui:option>
                               <aui:option value="automobiles" class="automobiles">Automobiles & Motorcycles</aui:option>
                               <aui:option value="apparel" class="apparel">Apparel</aui:option>
                               <aui:option value="beauty" class="beauty">Beauty & Personal Care</aui:option>
                               <aui:option value="chemicals" class="chemicals">Chemicals</aui:option>
                               <aui:option value="computer" class="comp">Computer</aui:option>
                               <aui:option value="construction" class="cons&eng">Construction & Engineering</aui:option>
                               <aui:option value="consumer" class="conselec">Consumer Electronics</aui:option>
                               <aui:option value="electronic" class="electcomp">Electronic Components</aui:option>
                               <aui:option value="electrical" class="electequi">Electrical Equipment</aui:option>
                               <aui:option value="energy" class="energy">Energy</aui:option>
                               <aui:option value="eyeware" class="eyeware">Eyeware</aui:option>
                               <aui:option value="franchise" class="franchise">Franchise</aui:option>
                               <aui:option value="fashion" class="fashionaccess">Fashion Accessories</aui:option>
                               <aui:option value="food" class="food&bever">Food & Beverages</aui:option>
                               <aui:option value="furniture" class="furniture">Furniture</aui:option>
                               <aui:option value="gift" class="gift&craft">Gift & Craft</aui:option>
                               <aui:option value="health" class="health&medical">Health & Medical</aui:option>
                               <aui:option value="appliances" class="homeapp">Home Appliances</aui:option>
                               <aui:option value="garden" class="garden">Home & Garden</aui:option>
                               <aui:option value="jewelery" class="jewel&watch">Jewelery & Watches</aui:option>
                               <aui:option value="light" class="light">Light & Lighting</aui:option>
                               <aui:option value="luggage" class="luggage">Luggage, Bags & Caeses</aui:option>
                               <aui:option value="machinery" class="machinery">Machinery</aui:option>
                               <aui:option value="mechanical" class="mechanical">Mechanical Parts</aui:option>
                               <aui:option value="minerals" class="min&metal">Minerals & Metallurgy</aui:option>
                               <aui:option value="packaging" class="pack">Packaging & Printing</aui:option>
                               <aui:option value="process" class="process">Process</aui:option>
                               <aui:option value="security" class="security">Security & Protection</aui:option>
                               <aui:option value="shoes" class="shoes&acc">Shoes & Accessories</aui:option>
                               <aui:option value="sports" class="sports">Sports & Entertainment</aui:option>
                               <aui:option value="textiles" class="textiles">Textiles & Leather Products</aui:option>
				</aui:select> -->
				<label>Industry</label>
				<select name="industry" class="form-control">
							   <option value="agriculture" class="agriculture">Agriculture</option>
                               <option value="automobiles" class="automobiles">Automobiles & Motorcycles</option>
                               <option value="apparel" class="apparel">Apparel</option>
                               <option value="beauty" class="beauty">Beauty & Personal Care</option>
                               <option value="chemicals" class="chemicals">Chemicals</option>
                               <option value="computer" class="comp">Computer</option>
                               <option value="construction" class="cons&eng">Construction & Engineering</option>
                               <option value="consumer" class="conselec">Consumer Electronics</option>
                               <option value="electronic" class="electcomp">Electronic Components</option>
                               <option value="electrical" class="electequi">Electrical Equipment</option>
                               <option value="energy" class="energy">Energy</option>
                               <option value="eyeware" class="eyeware">Eyeware</option>
                               <option value="franchise" class="franchise">Franchise</option>
                               <option value="fashion" class="fashionaccess">Fashion Accessories</option>
                               <option value="food" class="food&bever">Food & Beverages</option>
                               <option value="furniture" class="furniture">Furniture</option>
                               <option value="gift" class="gift&craft">Gift & Craft</option>
                               <option value="health" class="health&medical">Health & Medical</option>
                               <option value="appliances" class="homeapp">Home Appliances</option>
                               <option value="garden" class="garden">Home & Garden</option>
                               <option value="jewelery" class="jewel&watch">Jewelery & Watches</option>
                               <option value="light" class="light">Light & Lighting</option>
                               <option value="luggage" class="luggage">Luggage, Bags & Caeses</option>
                               <option value="machinery" class="machinery">Machinery</option>
                               <option value="mechanical" class="mechanical">Mechanical Parts</option>
                               <option value="minerals" class="min&metal">Minerals & Metallurgy</option>
                               <option value="packaging" class="pack">Packaging & Printing</option>
                               <option value="process" class="process">Process</option>
                               <option value="security" class="security">Security & Protection</option>
                               <option value="shoes" class="shoes&acc">Shoes & Accessories</option>
                               <option value="sports" class="sports">Sports & Entertainment</option>
                               <option value="textiles" class="textiles">Textiles & Leather Products</option>
				</select>
				<label>Primary Business</label>
			    <input type="text" name="primarybusiness" class="form-control" placeholder="Primary Business"/>
			 
				<!-- <aui:input label="Primary Purpose" name="primarypurpose" type="text" style="border-color:black; ">
					
				</aui:input> -->
				<label>Primary Purpose</label>
				<select name="primarypurpose" class="form-control">
					<option>--select--</option>
					<option value="1">Buy/Sell</option>
					<option value="2">Export</option>
					<option value="3">Import</option>
					<option value="4">Invest</option>
				</select>
				<!-- <aui:select label="Primary Purpose" name="primarypurpose"
					style=" width: 73%; height: 30px;border:2px solid black;">
					<aui:option>--select--</aui:option>
					<aui:option value="1">Buy/Sell</aui:option>
					<aui:option value="2">Export</aui:option>
					<aui:option value="3">Import</aui:option>
					<aui:option value="4">Invest</aui:option>
				</aui:select> -->
				
			</aui:column>
		</aui:fieldset>

		<aui:button-row>
		   <button class="btn btn-primary" type="submit" style="width:32%"><i class="fa fa-user"></i>&nbsp;<span>Create
				Account</span></button>
							
			<!-- <button type="submit" class="loginBtn" value="Register"
				style="width: 31%; color: black; font-weight: bold;">Create
				Account</button> -->
		</aui:button-row>
	  
	</aui:form>

	<liferay-util:include page="/html/portlet/login/navigation.jsp" />

	<c:if test="<%=windowState.equals(WindowState.MAXIMIZED)%>">
		<aui:script>
		Liferay.Util.focusFormField(document.<portlet:namespace />fm.<portlet:namespace />firstName);
	</aui:script>
	</c:if>
</body> 