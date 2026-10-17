
// import 'package:flutter/widgets.dart';

// class AppStrings {
//   // ============ Existing keys ============
//   final String promoTitle1Line1;
//   final String promoTitle1Line2;
//   final String promoDesc1;
//   final String promoTitle2Line1;
//   final String promoTitle2Line2;
//   final String promoDesc2;
//   final String promoTitle3Line1;
//   final String promoTitle3Line2;
//   final String promoDesc3;

//    final String ourBusinesses;
//   final String viewAll;
//   final String searchHint;
//   final String settings;
//   final String language;
//   final String chooseLanguage;
//   final String scanQrCode;
//   final String scanToViewMenu;
//   final String nearbyRestaurants;
//   final String popularCategories;
//   final String offers;
//   final String seeAll;
//   final String searchRestaurants;
//   final String getDirections;
//   final String menu;
//   final String noMenuAvailable;
//   final String home;
//   final String discover;
//   final String events;
//   final String profile;
//   final String restaurants;
//   final String filtered;
//   final String byDistance;
//   final String byReviews;
//   final String noRestaurantsFound;
//   final String noCategoriesAvailable;
//   final String searchRestaurantsOrPlaces;
//   final String searchDishesOrRestaurants;
//   final String reviews;
//   final String closed;
//   final String discoverFoods;
//   final String topRated;
//   final String nearby;
//   final String noDishesFound;
//   final String close;

//   // ============ QR Scanner ============
//   final String scanQrTitle;
//   final String pointCameraAtQr;
//   final String loadingMenu;
//   final String invalidQr;
//   final String couldNotLoadMenu;
//   final String couldNotOpenMaps;

//   // ============ Business / Food ============
//   final String open;
//   final String noName;
//   final String noLocation;
//   final String noDescription;
//   final String description;
//   final String addToCart;
//   final String addedToCart;

//   // ============ Auth — Login / Signup ============
//   final String welcomeBack;
//   final String loginSubtitle;
//   final String username;
//   final String password;
//   final String rememberMe;
//   final String forgotPassword;
//   final String logIn;
//   final String or;
//   final String continueWithGoogle;
//   final String dontHaveAccount;
//   final String signUp;
//   final String createAccount;
//   final String signupSubtitle;
//   final String fullNameHint;
//   final String emailAddress;
//   final String emailHint;
//   final String confirmPassword;
//   final String agreeToTerms;
//   final String and;
//   final String privacyPolicy;
//   final String alreadyHaveAccount;
//   final String loginSuccessfully;
//   final String loginFailed;
//   final String pleaseEnterUsernameAndPassword;
//   final String anErrorOccurred;
//   final String failedToGetIdToken;
//   final String googleLoginFailed;
//   final String somethingWentWrong;
//   final String googleSignUpComingSoon;

//   // ============ Validation ============
//   final String pleaseEnterFullName;
//   final String pleaseEnterValidEmail;
//   final String pleaseEnterValidPhone;
//   final String passwordMin6;
//   final String passwordsDoNotMatch;
//   final String pleaseAgreeToTerms;
//   final String accountCreatedSuccessfully;
//   final String registrationFailed;
//   final String networkError;
//   final String connectionError;

//   // ============ Create / Edit Profile ============
//   final String createProfile;
//   final String createProfileSubtitle;
//   final String enterFullName;
//   final String enterEmail;
//   final String enterPhone;
//   final String enterLocation;
//   final String selectBirthDate;
//   final String tellUsAboutYourself;
//   final String bio;
//   final String birthDate;
//   final String location;
//   final String skipForNow;
//   final String saveChanges;
//   final String profileCreatedSuccessfully;
//   final String tapPhotoToChange;
//   final String nameCannotBeEmpty;
//   final String enterValidEmail;

//   // ============ Profile View ============
//   final String profileId;
//   final String activity;
//   final String birthday;
//   final String about;
//   final String contactInformation;
//   final String notSet;
//   final String message;
//   final String edit;
//   final String retry;
//   final String messageComingSoon;

//   // ============ Settings ============
//   final String account;
//   final String editProfile;
//   final String updatePersonalInfo;
//   final String changePassword;
//   final String updateYourPassword;
//   final String emailSettings;
//   final String manageEmailPreferences;
//   final String login;
//   final String signInToYourAccount;
//   final String register;
//   final String createNewAccount;
//   final String preferences;
//   final String notifications;
//   final String pushNotifications;
//   final String theme;
//   final String darkMode;
//   final String support;
//   final String helpSupport;
//   final String getHelpWithMenuScan;
//   final String sendFeedback;
//   final String helpUsImprove;
//   final String version;
//   final String accountManagement;
//   final String logout;
//   final String signOutOfYourAccount;
//   final String deleteAccount;
//   final String permanentlyDeleteYourAccount;
//   final String active;
//   final String user;
//   final String email;
//   final String loggedOutSuccessfully;
//   final String areYouSureYouWantToLogout;
//   final String cancel;
//   final String delete;
//   final String thisActionCannotBeUndone;
//   final String fullName;
//   final String phoneNumber;
//   final String save;
//   final String saving;
//   final String profileUpdatedSuccessfully;
//   final String currentPassword;
//   final String newPassword;
//   final String confirmNewPassword;
//   final String updatePassword;
//   final String passwordChangedSuccessfully;
//   final String pleaseEnterYourName;
//   final String pleaseEnterYourEmail;
//   final String pleaseEnterYourCurrentPassword;
//   final String pleaseEnterANewPassword;
//   final String passwordMustBeAtLeast6Characters;
//   final String pleaseConfirmYourNewPassword;
//   final String emailNotifications;
//   final String orderUpdates;
//   final String dark;
//   final String light;
//   final String systemDefault;
//   final String english;
//   final String spanish;
//   final String french;
//   final String arabic;
//   final String korean;
//   final String japanese;
//   final String chinese;

//   // ============ Help / FAQ ============
//   final String howCanWeHelpYou;
//   final String findQuickAnswers;
//   final String frequentlyAskedQuestions;
//   final String faqHowDoIScanAMenu;
//   final String faqHowDoIScanAMenuAnswer;
//   final String faqDoINeedAccount;
//   final String faqDoINeedAccountAnswer;
//   final String faqWhyNoMenuLoading;
//   final String faqWhyNoMenuLoadingAnswer;
//   final String faqSaveFavorite;
//   final String faqSaveFavoriteAnswer;
//   final String faqIsDataSafe;
//   final String faqIsDataSafeAnswer;
//   final String contactSupport;
//   final String emailSupport;
//   final String emailSupportSubtitle;
//   final String reportProblem;
//   final String reportProblemSubtitle;
//   final String suggestFeature;
//   final String suggestFeatureSubtitle;
//   final String rateApp;
//   final String rateAppSubtitle;
//   final String madeWithLove;
//   final String yourFeedbackShapes;
//   final String greatReportIncludes;
//   final String tipWhatYouWereDoing;
//   final String tipWhatYouExpected;
//   final String tipWhatActuallyHappened;
//   final String tipIdeasForImproving;
//   final String shareYourFeedback;
//   final String submitFeedback;
//   final String loginToSendFeedback;
//   final String pleaseEnterFeedback;
//   final String feedbackSentThanks;
//   final String failedToSendFeedback;
//   final String foodDeliveryApp;

//   // ============ Post keys (formerly Event) ============
//   final String searchPosts;
//   final String searchPostsOrPlaces;
//   final String byDate;
//   final String byPopularity;
//   final String noPostsFound;
//   final String errorLoadingPosts;
//   final String errorLoadingMore;
//   final String failedToLoadPosts;
//   final String failedToToggleLike;
//   final String failedToSharePost;
//   final String userNotAuthenticated;
//   final String unknownErrorOccurred;
//   final String checkOutThisPost;
//   final String checkOut;
//   final String like;
//   final String likes;
//   final String comment;
//   final String comments;
//   final String share;
//   final String shares;
//   final String showMore;
//   final String showLess;
//   final String date;
//   final String time;
//   final String organizer;
//   final String sideBar;
//   final String post;
//   final String integrateQrHint;

//   // ============ About Page ============
//   final String aboutTitle;
//   final String digitalMenus;
//   final String digitalMenusSubtitle;
//   final String fastScanning;
//   final String fastScanningSubtitle;
//   final String savedEvents;
//   final String savedEventsSubtitle;
//   final String shareMenus;
//   final String shareMenusSubtitle;
//   final String rateUs;
//   final String madeWithLoveBy;
//   final String allRightsReserved;

//   // ============ Contact Support Page ============
//   final String weAreHereToHelp;
//   final String contactSupportSubtitle;
//   final String reachUs;
//   final String emailSupportAddress;
//   final String emailSupportDesc;
//   final String reportBug;
//   final String reportBugAddress;
//   final String reportBugDesc;
//   final String privacyInquiries;
//   final String privacyInquiriesAddress;
//   final String privacyInquiriesDesc;
//   final String legal;
//   final String legalAddress;
//   final String legalDesc;
//   final String beforeYouWrite;
//   final String includeTheseDetails;
//   final String yourAccountEmail;
//   final String appVersion;
//   final String deviceAndOs;
//   final String stepsToReproduce;
//   final String screenshots;
//   final String responseTimes;
//   final String generalInquiries;
//   final String bugReports;
//   final String privacyRequests;
//   final String criticalIssues;
//   final String followUs;
//   final String website;
//   final String twitter;
//   final String instagram;
//   final String sendInAppFeedback;
//   final String weReadEveryMessage;

//   // ============ Privacy Policy Page ============
//   final String yourPrivacyMatters;
//   final String privacyIntro;
//   final String lastUpdated;
//   final String informationWeCollect;
//   final String informationWeCollectBody;
//   final String howWeUseYourData;
//   final String howWeUseYourDataBody;
//   final String sharingThirdParties;
//   final String sharingThirdPartiesBody;
//   final String dataRetention;
//   final String dataRetentionBody;
//   final String yourRights;
//   final String yourRightsBody;
//   final String cookiesTracking;
//   final String cookiesTrackingBody;
//   final String childrensPrivacy;
//   final String childrensPrivacyBody;
//   final String changesToThisPolicy;
//   final String changesToThisPolicyBody;
//   final String contactUs;
//   final String contactUsBody;

//   // ============ Terms of Service Page ============
//   final String termsOfService;
//   final String rulesOfUsing;
//   final String termsIntro;
//   final String effective;
//   final String acceptanceOfTerms;
//   final String acceptanceOfTermsBody;
//   final String yourAccount;
//   final String yourAccountBody;
//   final String acceptableUse;
//   final String acceptableUseBody;
//   final String menuContent;
//   final String menuContentBody;
//   final String intellectualProperty;
//   final String intellectualPropertyBody;
//   final String serviceAvailability;
//   final String serviceAvailabilityBody;
//   final String limitationOfLiability;
//   final String limitationOfLiabilityBody;
//   final String termination;
//   final String terminationBody;
//   final String changesToTerms;
//   final String changesToTermsBody;
//   final String contact;
//   final String contactBody;

//   // ============ Theme Settings Page ============
//   final String appearance;
//   final String chooseYourLook;
//   final String appearanceSubtitle;
//   final String themeMode;
//   final String systemDefaultSubtitle;
//   final String lightSubtitle;
//   final String darkSubtitle;
//   final String preview;
//   final String sampleMenuItem;
//   final String sampleMenuItemDesc;
//   final String primary;
//   final String secondary;
//   final String systemDefaultInfo;

//   // ============ Change Password ============
//   final String notAuthenticated;
//   final String passwordMin8;
//   final String newPasswordsDoNotMatch;

//   // ============ Delete Account ============
//   final String deleteAccountConfirm;
//   final String deleteMyAccount;
//   final String yourAccountHasBeenDeleted;
//   final String failedToDeleteAccount;
//   final String notLoggedIn;

//   // ============ Feedback ============
//   final String feedback;
//   final String shareFeedback;
//   final String feedbackIntro;
//   final String feedbackType;
//   final String bugReport;
//   final String featureRequest;
//   final String generalFeedback;
//   final String feedbackMessage;
//   final String submit;
//   final String submitting;
//   final String feedbackSubmitted;
//   final String feedbackFailed;
//   final String pleaseEnterMessage;

//   // ============ General ============
//   final String loading;
//   final String error;
//   final String success;
//   final String ok;
//   final String yes;
//   final String no;
//   final String back;

//   const AppStrings({
//      required this.ourBusinesses,
//     required this.viewAll,
//     required this.searchHint,
//       required this.promoTitle1Line1,
//     required this.promoTitle1Line2,
//     required this.promoDesc1,
//     required this.promoTitle2Line1,
//     required this.promoTitle2Line2,
//     required this.promoDesc2,
//     required this.promoTitle3Line1,
//     required this.promoTitle3Line2,
//     required this.promoDesc3,

//     required this.settings,
//     required this.language,
//     required this.chooseLanguage,
//     required this.scanQrCode,
//     required this.scanToViewMenu,
//     required this.nearbyRestaurants,
//     required this.popularCategories,
//     required this.offers,
//     required this.seeAll,
//     required this.searchRestaurants,
//     required this.getDirections,
//     required this.menu,
//     required this.noMenuAvailable,
//     required this.home,
//     required this.discover,
//     required this.events,
//     required this.profile,
//     required this.restaurants,
//     required this.filtered,
//     required this.byDistance,
//     required this.byReviews,
//     required this.noRestaurantsFound,
//     required this.noCategoriesAvailable,
//     required this.searchRestaurantsOrPlaces,
//     required this.searchDishesOrRestaurants,
//     required this.reviews,
//     required this.closed,
//     required this.discoverFoods,
//     required this.topRated,
//     required this.nearby,
//     required this.noDishesFound,
//     required this.close,

//     required this.scanQrTitle,
//     required this.pointCameraAtQr,
//     required this.loadingMenu,
//     required this.invalidQr,
//     required this.couldNotLoadMenu,
//     required this.couldNotOpenMaps,

//     required this.open,
//     required this.noName,
//     required this.noLocation,
//     required this.noDescription,
//     required this.description,
//     required this.addToCart,
//     required this.addedToCart,

//     required this.welcomeBack,
//     required this.loginSubtitle,
//     required this.username,
//     required this.password,
//     required this.rememberMe,
//     required this.forgotPassword,
//     required this.logIn,
//     required this.or,
//     required this.continueWithGoogle,
//     required this.dontHaveAccount,
//     required this.signUp,
//     required this.createAccount,
//     required this.signupSubtitle,
//     required this.fullNameHint,
//     required this.emailAddress,
//     required this.emailHint,
//     required this.confirmPassword,
//     required this.agreeToTerms,
//     required this.and,
//     required this.privacyPolicy,
//     required this.alreadyHaveAccount,
//     required this.loginSuccessfully,
//     required this.loginFailed,
//     required this.pleaseEnterUsernameAndPassword,
//     required this.anErrorOccurred,
//     required this.failedToGetIdToken,
//     required this.googleLoginFailed,
//     required this.somethingWentWrong,
//     required this.googleSignUpComingSoon,

//     required this.pleaseEnterFullName,
//     required this.pleaseEnterValidEmail,
//     required this.pleaseEnterValidPhone,
//     required this.passwordMin6,
//     required this.passwordsDoNotMatch,
//     required this.pleaseAgreeToTerms,
//     required this.accountCreatedSuccessfully,
//     required this.registrationFailed,
//     required this.networkError,
//     required this.connectionError,

//     required this.createProfile,
//     required this.createProfileSubtitle,
//     required this.enterFullName,
//     required this.enterEmail,
//     required this.enterPhone,
//     required this.enterLocation,
//     required this.selectBirthDate,
//     required this.tellUsAboutYourself,
//     required this.bio,
//     required this.birthDate,
//     required this.location,
//     required this.skipForNow,
//     required this.saveChanges,
//     required this.profileCreatedSuccessfully,
//     required this.tapPhotoToChange,
//     required this.nameCannotBeEmpty,
//     required this.enterValidEmail,

//     required this.profileId,
//     required this.activity,
//     required this.birthday,
//     required this.about,
//     required this.contactInformation,
//     required this.notSet,
//     required this.message,
//     required this.edit,
//     required this.retry,
//     required this.messageComingSoon,

//     required this.account,
//     required this.editProfile,
//     required this.updatePersonalInfo,
//     required this.changePassword,
//     required this.updateYourPassword,
//     required this.emailSettings,
//     required this.manageEmailPreferences,
//     required this.login,
//     required this.signInToYourAccount,
//     required this.register,
//     required this.createNewAccount,
//     required this.preferences,
//     required this.notifications,
//     required this.pushNotifications,
//     required this.theme,
//     required this.darkMode,
//     required this.support,
//     required this.helpSupport,
//     required this.getHelpWithMenuScan,
//     required this.sendFeedback,
//     required this.helpUsImprove,
//     required this.version,
//     required this.accountManagement,
//     required this.logout,
//     required this.signOutOfYourAccount,
//     required this.deleteAccount,
//     required this.permanentlyDeleteYourAccount,
//     required this.active,
//     required this.user,
//     required this.email,
//     required this.loggedOutSuccessfully,
//     required this.areYouSureYouWantToLogout,
//     required this.cancel,
//     required this.delete,
//     required this.thisActionCannotBeUndone,
//     required this.fullName,
//     required this.phoneNumber,
//     required this.save,
//     required this.saving,
//     required this.profileUpdatedSuccessfully,
//     required this.currentPassword,
//     required this.newPassword,
//     required this.confirmNewPassword,
//     required this.updatePassword,
//     required this.passwordChangedSuccessfully,
//     required this.pleaseEnterYourName,
//     required this.pleaseEnterYourEmail,
//     required this.pleaseEnterYourCurrentPassword,
//     required this.pleaseEnterANewPassword,
//     required this.passwordMustBeAtLeast6Characters,
//     required this.pleaseConfirmYourNewPassword,
//     required this.emailNotifications,
//     required this.orderUpdates,
//     required this.dark,
//     required this.light,
//     required this.systemDefault,
//     required this.english,
//     required this.spanish,
//     required this.french,
//     required this.arabic,
//     required this.korean,
//     required this.japanese,
//     required this.chinese,

//     required this.howCanWeHelpYou,
//     required this.findQuickAnswers,
//     required this.frequentlyAskedQuestions,
//     required this.faqHowDoIScanAMenu,
//     required this.faqHowDoIScanAMenuAnswer,
//     required this.faqDoINeedAccount,
//     required this.faqDoINeedAccountAnswer,
//     required this.faqWhyNoMenuLoading,
//     required this.faqWhyNoMenuLoadingAnswer,
//     required this.faqSaveFavorite,
//     required this.faqSaveFavoriteAnswer,
//     required this.faqIsDataSafe,
//     required this.faqIsDataSafeAnswer,
//     required this.contactSupport,
//     required this.emailSupport,
//     required this.emailSupportSubtitle,
//     required this.reportProblem,
//     required this.reportProblemSubtitle,
//     required this.suggestFeature,
//     required this.suggestFeatureSubtitle,
//     required this.rateApp,
//     required this.rateAppSubtitle,
//     required this.madeWithLove,
//     required this.yourFeedbackShapes,
//     required this.greatReportIncludes,
//     required this.tipWhatYouWereDoing,
//     required this.tipWhatYouExpected,
//     required this.tipWhatActuallyHappened,
//     required this.tipIdeasForImproving,
//     required this.shareYourFeedback,
//     required this.submitFeedback,
//     required this.loginToSendFeedback,
//     required this.pleaseEnterFeedback,
//     required this.feedbackSentThanks,
//     required this.failedToSendFeedback,
//     required this.foodDeliveryApp,

//     required this.searchPosts,
//     required this.searchPostsOrPlaces,
//     required this.byDate,
//     required this.byPopularity,
//     required this.noPostsFound,
//     required this.errorLoadingPosts,
//     required this.errorLoadingMore,
//     required this.failedToLoadPosts,
//     required this.failedToToggleLike,
//     required this.failedToSharePost,
//     required this.userNotAuthenticated,
//     required this.unknownErrorOccurred,
//     required this.checkOutThisPost,
//     required this.checkOut,
//     required this.like,
//     required this.likes,
//     required this.comment,
//     required this.comments,
//     required this.share,
//     required this.shares,
//     required this.showMore,
//     required this.showLess,
//     required this.date,
//     required this.time,
//     required this.organizer,
//     required this.sideBar,
//     required this.post,
//     required this.integrateQrHint,

//     required this.aboutTitle,
//     required this.digitalMenus,
//     required this.digitalMenusSubtitle,
//     required this.fastScanning,
//     required this.fastScanningSubtitle,
//     required this.savedEvents,
//     required this.savedEventsSubtitle,
//     required this.shareMenus,
//     required this.shareMenusSubtitle,
//     required this.rateUs,
//     required this.madeWithLoveBy,
//     required this.allRightsReserved,

//     required this.weAreHereToHelp,
//     required this.contactSupportSubtitle,
//     required this.reachUs,
//     required this.emailSupportAddress,
//     required this.emailSupportDesc,
//     required this.reportBug,
//     required this.reportBugAddress,
//     required this.reportBugDesc,
//     required this.privacyInquiries,
//     required this.privacyInquiriesAddress,
//     required this.privacyInquiriesDesc,
//     required this.legal,
//     required this.legalAddress,
//     required this.legalDesc,
//     required this.beforeYouWrite,
//     required this.includeTheseDetails,
//     required this.yourAccountEmail,
//     required this.appVersion,
//     required this.deviceAndOs,
//     required this.stepsToReproduce,
//     required this.screenshots,
//     required this.responseTimes,
//     required this.generalInquiries,
//     required this.bugReports,
//     required this.privacyRequests,
//     required this.criticalIssues,
//     required this.followUs,
//     required this.website,
//     required this.twitter,
//     required this.instagram,
//     required this.sendInAppFeedback,
//     required this.weReadEveryMessage,

//     required this.yourPrivacyMatters,
//     required this.privacyIntro,
//     required this.lastUpdated,
//     required this.informationWeCollect,
//     required this.informationWeCollectBody,
//     required this.howWeUseYourData,
//     required this.howWeUseYourDataBody,
//     required this.sharingThirdParties,
//     required this.sharingThirdPartiesBody,
//     required this.dataRetention,
//     required this.dataRetentionBody,
//     required this.yourRights,
//     required this.yourRightsBody,
//     required this.cookiesTracking,
//     required this.cookiesTrackingBody,
//     required this.childrensPrivacy,
//     required this.childrensPrivacyBody,
//     required this.changesToThisPolicy,
//     required this.changesToThisPolicyBody,
//     required this.contactUs,
//     required this.contactUsBody,

//     required this.termsOfService,
//     required this.rulesOfUsing,
//     required this.termsIntro,
//     required this.effective,
//     required this.acceptanceOfTerms,
//     required this.acceptanceOfTermsBody,
//     required this.yourAccount,
//     required this.yourAccountBody,
//     required this.acceptableUse,
//     required this.acceptableUseBody,
//     required this.menuContent,
//     required this.menuContentBody,
//     required this.intellectualProperty,
//     required this.intellectualPropertyBody,
//     required this.serviceAvailability,
//     required this.serviceAvailabilityBody,
//     required this.limitationOfLiability,
//     required this.limitationOfLiabilityBody,
//     required this.termination,
//     required this.terminationBody,
//     required this.changesToTerms,
//     required this.changesToTermsBody,
//     required this.contact,
//     required this.contactBody,

//     required this.appearance,
//     required this.chooseYourLook,
//     required this.appearanceSubtitle,
//     required this.themeMode,
//     required this.systemDefaultSubtitle,
//     required this.lightSubtitle,
//     required this.darkSubtitle,
//     required this.preview,
//     required this.sampleMenuItem,
//     required this.sampleMenuItemDesc,
//     required this.primary,
//     required this.secondary,
//     required this.systemDefaultInfo,

//     required this.notAuthenticated,
//     required this.passwordMin8,
//     required this.newPasswordsDoNotMatch,

//     required this.deleteAccountConfirm,
//     required this.deleteMyAccount,
//     required this.yourAccountHasBeenDeleted,
//     required this.failedToDeleteAccount,
//     required this.notLoggedIn,

//     required this.feedback,
//     required this.shareFeedback,
//     required this.feedbackIntro,
//     required this.feedbackType,
//     required this.bugReport,
//     required this.featureRequest,
//     required this.generalFeedback,
//     required this.feedbackMessage,
//     required this.submit,
//     required this.submitting,
//     required this.feedbackSubmitted,
//     required this.feedbackFailed,
//     required this.pleaseEnterMessage,

//     required this.loading,
//     required this.error,
//     required this.success,
//     required this.ok,
//     required this.yes,
//     required this.no,
//     required this.back,
//   });

//   static const Map<String, AppStrings> _values = {
//     // ====================================================================
//     // ============================== ENGLISH =============================
//     // ====================================================================
//     'en': AppStrings(
//       settings: 'Settings',
//       language: 'Language',
//       chooseLanguage: 'Choose Language',
//       scanQrCode: 'Scan QR Code',
//       scanToViewMenu: 'Scan to view menu & order instantly',
//       nearbyRestaurants: 'Nearby Businesses',
//       popularCategories: 'Popular Categories',
//       offers: 'Offers',
//       seeAll: 'See all',
//       searchRestaurants: 'Search businesses by name...',
//       getDirections: 'Get Directions',
//       menu: 'Products & Items',
//       noMenuAvailable: 'No Menu Available',
//       home: 'Home',
//       discover: 'Discover',
//       events: 'Posts',
//       profile: 'Profile',
//       restaurants: 'Businesses',
//       filtered: 'Filtered',
//       byDistance: 'By Distance',
//       byReviews: 'By Reviews',
//       noRestaurantsFound: 'No businesses found',
//       noCategoriesAvailable: 'No categories available',
//       searchRestaurantsOrPlaces: 'Search businesses or places...',
//       searchDishesOrRestaurants: 'Search dishes or businesses...',
//       reviews: 'reviews',
//       closed: 'Closed',
//       discoverFoods: 'Discover Foods',
//       topRated: 'Top Rated Businesses',
//       nearby: 'Nearby Businesses',
//       noDishesFound: 'No dishes found',
//       close: 'Close',

//       scanQrTitle: 'Scan QR Code',
//       pointCameraAtQr: 'Point camera at the QR code on the table',
//       loadingMenu: 'Loading menu...',
//       invalidQr: 'Invalid QR code. Please scan a business menu QR.',
//       couldNotLoadMenu:
//           'Could not load menu. Please make sure the backend is running.',
//       couldNotOpenMaps: 'Could not open Google Maps',

//       open: 'Open',
//       noName: 'No Name',
//       noLocation: 'No Location',
//       noDescription: 'No Description',
//       description: 'Description',
//       addToCart: 'Add to Cart',
//       addedToCart: 'Added to cart',

//       welcomeBack: 'Welcome Back!',
//       loginSubtitle:
//           'Log in to your account to continue\nordering and managing your menu.',
//       username: 'Username',
//       password: 'Password',
//       rememberMe: 'Remember me',
//       forgotPassword: 'Forgot Password?',
//       logIn: 'Log In',
//       or: 'or',
//       continueWithGoogle: 'Continue with Google',
//       dontHaveAccount: "Don't have an account? ",
//       signUp: 'Sign Up',
//       createAccount: 'Create Account',
//       signupSubtitle:
//           'Sign up to start exploring and\nmanaging your favorite businesses.',
//       fullNameHint: 'Full Name',
//       emailAddress: 'Email Address',
//       emailHint: 'Email',
//       confirmPassword: 'Confirm Password',
//       agreeToTerms: 'I agree to the ',
//       and: ' and ',
//       privacyPolicy: 'Privacy Policy',
//       alreadyHaveAccount: 'Already have an account? ',
//       loginSuccessfully: 'Login Successfully',
//       loginFailed:
//           'Check Internet Connection Or incorrect username & password',
//       pleaseEnterUsernameAndPassword: 'Please enter username and password',
//       anErrorOccurred: 'An error occurred. Please try again.',
//       failedToGetIdToken: 'Failed to get ID token from Google.',
//       googleLoginFailed: 'Google login failed.',
//       somethingWentWrong: 'Something went wrong. Please try again.',
//       googleSignUpComingSoon: 'Google Sign Up coming soon!',

//       pleaseEnterFullName: 'Please enter your full name',
//       pleaseEnterValidEmail: 'Please enter a valid email address',
//       pleaseEnterValidPhone: 'Please enter a valid phone number',
//       passwordMin6: 'Password must be at least 6 characters',
//       passwordsDoNotMatch: 'Passwords do not match',
//       pleaseAgreeToTerms: 'Please agree to the Terms & Conditions',
//       accountCreatedSuccessfully: 'Account created successfully!',
//       registrationFailed: 'Registration failed',
//       networkError: 'Network error. Please check your connection.',
//       connectionError: 'Connection error. Please try again.',

//       createProfile: 'Create Profile',
//       createProfileSubtitle:
//           'Complete your profile to get started\nand connect with amazing businesses.',
//       enterFullName: 'Enter your full name',
//       enterEmail: 'Enter your email address',
//       enterPhone: 'Enter your phone number',
//       enterLocation: 'Enter your location',
//       selectBirthDate: 'Select your birth date',
//       tellUsAboutYourself: 'Tell us about yourself',
//       bio: 'Bio',
//       birthDate: 'Birth Date',
//       location: 'Location',
//       skipForNow: 'Skip for now',
//       saveChanges: 'Save Changes',
//       profileCreatedSuccessfully: 'Profile created successfully!',
//       tapPhotoToChange: 'Tap on the photo to change',
//       nameCannotBeEmpty: 'Name cannot be empty',
//       enterValidEmail: 'Enter a valid email',

//       profileId: 'Profile ID',
//       activity: 'Activity',
//       birthday: 'Birthday',
//       about: 'About',
//       contactInformation: 'Contact Information',
//       notSet: 'Not set',
//       message: 'Message',
//       edit: 'Edit',
//       retry: 'Retry',
//       messageComingSoon: 'Message feature coming soon',

//       account: 'Account',
//       editProfile: 'Edit Profile',
//       updatePersonalInfo: 'Update your personal information',
//       changePassword: 'Change Password',
//       updateYourPassword: 'Update your password',
//       emailSettings: 'Email Settings',
//       manageEmailPreferences: 'Manage email preferences',
//       login: 'Login',
//       signInToYourAccount: 'Sign in to your account',
//       register: 'Register',
//       createNewAccount: 'Create a new account',
//       preferences: 'Preferences',
//       notifications: 'Notifications',
//       pushNotifications: 'Push notifications',
//       theme: 'Theme',
//       darkMode: 'Dark Mode',
//       support: 'Support',
//       helpSupport: 'Help & Support',
//       getHelpWithMenuScan: 'Get help with MenuScan',
//       sendFeedback: 'Send Feedback',
//       helpUsImprove: 'Help us improve',
//       version: 'Version 1.0.0',
//       accountManagement: 'Account Management',
//       logout: 'Logout',
//       signOutOfYourAccount: 'Sign out of your account',
//       deleteAccount: 'Delete Account',
//       permanentlyDeleteYourAccount: 'Permanently delete your account',
//       active: 'Active',
//       user: 'User',
//       email: 'Email',
//       loggedOutSuccessfully: 'Logged out successfully',
//       areYouSureYouWantToLogout: 'Are you sure you want to logout?',
//       cancel: 'Cancel',
//       delete: 'Delete',
//       thisActionCannotBeUndone:
//           'This action cannot be undone. Are you sure you want to delete your account permanently?',
//       fullName: 'Full Name',
//       phoneNumber: 'Phone Number',
//       save: 'Save',
//       saving: 'Saving...',
//       profileUpdatedSuccessfully: 'Profile updated successfully',
//       currentPassword: 'Current Password',
//       newPassword: 'New Password',
//       confirmNewPassword: 'Confirm New Password',
//       updatePassword: 'Update Password',
//       passwordChangedSuccessfully: 'Password changed successfully',
//       pleaseEnterYourName: 'Please enter your name',
//       pleaseEnterYourEmail: 'Please enter your email',
//       pleaseEnterYourCurrentPassword: 'Please enter your current password',
//       pleaseEnterANewPassword: 'Please enter a new password',
//       passwordMustBeAtLeast6Characters:
//           'Password must be at least 6 characters',
//       pleaseConfirmYourNewPassword: 'Please confirm your new password',
//       emailNotifications: 'Email Notifications',
//       orderUpdates: 'Order Updates',
//       dark: 'Dark',
//       light: 'Light',
//       systemDefault: 'System Default',
//       english: 'English',
//       spanish: 'Spanish',
//       french: 'French',
//       arabic: 'Arabic',
//       korean: 'Korean',
//       japanese: 'Japanese',
//       chinese: 'Chinese',

//       howCanWeHelpYou: 'How can we help you?',
//       findQuickAnswers:
//           'Find quick answers below, or reach out directly — we usually reply within 1–2 business days.',
//       frequentlyAskedQuestions: 'Frequently Asked Questions',
//       faqHowDoIScanAMenu: 'How do I scan a menu?',
//       faqHowDoIScanAMenuAnswer:
//           "Open the app, tap the scan button on the home screen, and point your camera at the business's QR code. The digital menu will load automatically — no download needed.",
//       faqDoINeedAccount: 'Do I need an account to use MenuScan?',
//       faqDoINeedAccountAnswer:
//           'You can browse menus as a guest. An account is only required to save favorite dishes, send feedback, or sync across devices.',
//       faqWhyNoMenuLoading: "Why isn't a menu loading?",
//       faqWhyNoMenuLoadingAnswer:
//           "Check your internet connection first. If the QR code is old or the business hasn't updated its menu, try asking staff for a new code. You can also report the issue from the menu screen.",
//       faqSaveFavorite: 'How do I save a dish to favorites?',
//       faqSaveFavoriteAnswer:
//           'Tap the heart icon next to any dish while viewing a menu. Saved dishes appear under Profile → Favorites.',
//       faqIsDataSafe: 'Is my data safe?',
//       faqIsDataSafeAnswer:
//           'Yes. We never store payment data, and your scans are not shared with third parties. See our Privacy Policy for full details.',
//       contactSupport: 'Contact & Support',
//       emailSupport: 'Email Support',
//       emailSupportSubtitle: 'support@menuscan.com — replies in 1–2 days',
//       reportProblem: 'Report a Problem',
//       reportProblemSubtitle:
//           "Found a bug? Send us the details and we'll fix it fast.",
//       suggestFeature: 'Suggest a Feature',
//       suggestFeatureSubtitle:
//           'Tell us what would make MenuScan better for you.',
//       rateApp: 'Rate the App',
//       rateAppSubtitle: 'Enjoying MenuScan? A review helps us a lot.',
//       madeWithLove: 'MenuScan v1.0.0  •  Made with ❤️',
//       yourFeedbackShapes:
//           "Your feedback directly shapes what we build next. Whether it's a bug, a missing feature, or a small idea — we read every message.",
//       greatReportIncludes: 'A great report includes:',
//       tipWhatYouWereDoing: 'What you were doing',
//       tipWhatYouExpected: 'What you expected to happen',
//       tipWhatActuallyHappened: 'What actually happened',
//       tipIdeasForImproving: 'Ideas for improving the app',
//       shareYourFeedback: 'Share your feedback...',
//       submitFeedback: 'Submit Feedback',
//       loginToSendFeedback: 'Login to send Feedback',
//       pleaseEnterFeedback: 'Please enter your feedback before submitting.',
//       feedbackSentThanks: 'Feedback sent! Thank you!',
//       failedToSendFeedback:
//           'Failed to send feedback. Please try again later.',
//       foodDeliveryApp: 'Food Delivery App',

//       searchPosts: 'Search posts...',
//       searchPostsOrPlaces: 'Search posts or places...',
//       byDate: 'By Date',
//       byPopularity: 'By Popularity',
//       noPostsFound: 'No posts found',
//       errorLoadingPosts: 'Error loading posts',
//       errorLoadingMore: 'Error loading more',
//       failedToLoadPosts: 'Failed to load posts',
//       failedToToggleLike: 'Failed to toggle like',
//       failedToSharePost: 'Failed to share post',
//       userNotAuthenticated:
//           'User not authenticated. Please login first.',
//       unknownErrorOccurred: 'Unknown error occurred',
//       checkOutThisPost: 'Check out this post!',
//       checkOut: 'Check out:',
//       like: 'Like',
//       likes: 'Likes',
//       comment: 'Comment',
//       comments: 'Comments',
//       share: 'Share',
//       shares: 'Shares',
//       showMore: 'Show more',
//       showLess: 'Show less',
//       date: 'Date',
//       time: 'Time',
//       organizer: 'Organizer',
//       sideBar: 'Sidebar',
//       post: 'Post',
//       integrateQrHint: 'Integrate your mobile_scanner package here',

//       aboutTitle: 'About',
//       digitalMenus: 'Digital Menus',
//       digitalMenusSubtitle: 'Scan QR codes to browse menus instantly',
//       fastScanning: 'Fast Scanning',
//       fastScanningSubtitle: 'Built-in scanner for quick access',
//       savedEvents: 'Saved Events',
//       savedEventsSubtitle: 'Events you bookmarked',
//       shareMenus: 'Share Menus',
//       shareMenusSubtitle: 'Send menus to friends and family',
//       rateUs: 'Rate Us',
//       madeWithLoveBy: 'Made with ❤️ by MenuScan Team',
//       allRightsReserved: '© 2025 MenuScan. All rights reserved.',

//       weAreHereToHelp: 'We\'re here to help',
//       contactSupportSubtitle:
//           'Pick the channel that fits your question. We reply to most messages within 1–2 business days.',
//       reachUs: 'Reach Us',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: 'General questions & account help',
//       reportBug: 'Report a Bug',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: 'Crashes, glitches, or broken menus',
//       privacyInquiries: 'Privacy Inquiries',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: 'Data access, deletion, or concerns',
//       legal: 'Legal',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: 'Terms, licensing, trademark matters',
//       beforeYouWrite: 'Before You Write',
//       includeTheseDetails: 'Include these details so we can help faster:',
//       yourAccountEmail: 'Your account email (if applicable)',
//       appVersion: 'App version (Settings → About)',
//       deviceAndOs: 'Device & OS (e.g., Pixel 7, Android 14)',
//       stepsToReproduce: 'Steps to reproduce the issue',
//       screenshots: 'Screenshots or screen recording',
//       responseTimes: 'Response Times',
//       generalInquiries: 'General inquiries',
//       bugReports: 'Bug reports',
//       privacyRequests: 'Privacy requests',
//       criticalIssues: 'Critical issues',
//       followUs: 'Follow Us',
//       website: 'Website',
//       twitter: 'Twitter',
//       instagram: 'Instagram',
//       sendInAppFeedback: 'Send In-App Feedback',
//       weReadEveryMessage:
//           'We read every message. Thank you for helping us improve.',

//       yourPrivacyMatters: 'Your privacy matters',
//       privacyIntro:
//           'This policy explains what data MenuScan collects, why we collect it, and how you stay in control. Plain language, no legal tricks.',
//       lastUpdated: 'Last updated: January 2025',
//       informationWeCollect: 'Information We Collect',
//       informationWeCollectBody:
//           'We collect only what\'s needed to run MenuScan:\n\n• Account data — email and username when you sign up.\n• Usage data — which menus you scan, viewed dishes, and app crashes (anonymized).\n• Device data — OS version and app version, used for bug fixing.\n• Feedback — anything you voluntarily send us.',
//       howWeUseYourData: 'How We Use Your Data',
//       howWeUseYourDataBody:
//           'Your data is used to:\n\n• Show you digital menus from scanned QR codes.\n• Sync your favorites across devices.\n• Improve app performance and fix bugs.\n• Respond to your support requests.\n\nWe never sell your data to advertisers or third parties.',
//       sharingThirdParties: 'Sharing & Third Parties',
//       sharingThirdPartiesBody:
//           'We share data only with essential service providers (hosting, analytics, crash reporting) under strict contracts. We do not share personal data with businesses or marketers without your explicit consent.',
//       dataRetention: 'Data Retention',
//       dataRetentionBody:
//           'Account data is kept while your account is active. Anonymous usage data is retained up to 12 months. Feedback is stored until resolved plus 6 months. You can request deletion at any time.',
//       yourRights: 'Your Rights',
//       yourRightsBody:
//           'You have the right to:\n\n• Access a copy of your data.\n• Correct inaccurate information.\n• Delete your account and associated data.\n• Opt out of non-essential analytics.\n\nTo exercise any of these, email privacy@menuscan.com.',
//       cookiesTracking: 'Cookies & Tracking',
//       cookiesTrackingBody:
//           'The mobile app does not use cookies. Analytics is limited to anonymized event tracking that can be disabled in Settings → Privacy.',
//       childrensPrivacy: 'Children\'s Privacy',
//       childrensPrivacyBody:
//           'MenuScan is not intended for children under 13. We do not knowingly collect data from children. If you believe a child has provided data, contact us for immediate removal.',
//       changesToThisPolicy: 'Changes to This Policy',
//       changesToThisPolicyBody:
//           'We\'ll notify you in-app before any material changes take effect. Continued use after that date means you accept the updated policy.',
//       contactUs: 'Contact Us',
//       contactUsBody:
//           'Questions about privacy? Reach us at:\n\nEmail: privacy@menuscan.com\nResponse time: 1–2 business days.',

//       termsOfService: 'Terms of Service',
//       rulesOfUsing: 'The rules of using MenuScan',
//       termsIntro:
//           'By downloading or using MenuScan, you agree to these terms. Please read them — they define what you can expect from us, and what we expect from you.',
//       effective: 'Effective: January 2025',
//       acceptanceOfTerms: '1. Acceptance of Terms',
//       acceptanceOfTermsBody:
//           'By creating an account or using MenuScan, you confirm you are at least 13 years old and agree to these terms. If you do not agree, please do not use the app.',
//       yourAccount: '2. Your Account',
//       yourAccountBody:
//           'You are responsible for:\n\n• Keeping your login credentials secure.\n• All activity that happens under your account.\n• Notifying us immediately of any unauthorized use.\n\nWe may suspend accounts that violate these terms.',
//       acceptableUse: '3. Acceptable Use',
//       acceptableUseBody:
//           'You agree NOT to:\n\n• Reverse-engineer, copy, or resell the app.\n• Upload malicious code or attempt to disrupt the service.\n• Scrape menus or user data without permission.\n• Submit false, abusive, or illegal content via feedback.\n\nViolations may result in permanent account termination.',
//       menuContent: '4. Menu Content',
//       menuContentBody:
//           'Menu data is provided by businesses. While we work to keep information accurate, we do not guarantee prices, allergens, or availability. Always confirm with business staff before ordering, especially for allergies.',
//       intellectualProperty: '5. Intellectual Property',
//       intellectualPropertyBody:
//           'The MenuScan name, logo, and app code are owned by us. Menu content belongs to the respective businesses. You may not use our branding without written permission.',
//       serviceAvailability: '6. Service Availability',
//       serviceAvailabilityBody:
//           'We aim for 99% uptime but do not guarantee uninterrupted service. We may temporarily suspend access for maintenance, updates, or reasons beyond our control.',
//       limitationOfLiability: '7. Limitation of Liability',
//       limitationOfLiabilityBody:
//           'MenuScan is provided "as is." To the maximum extent permitted by law, we are not liable for indirect damages arising from your use of the app, including incorrect menu information.',
//       termination: '8. Termination',
//       terminationBody:
//           'You may delete your account at any time from Settings. We may terminate or suspend access if these terms are violated, with or without notice.',
//       changesToTerms: '9. Changes to Terms',
//       changesToTermsBody:
//           'We may update these terms occasionally. Significant changes will be announced in-app. Continued use after changes means you accept the new terms.',
//       contact: '10. Contact',
//       contactBody: 'Questions about these terms?\n\nEmail: legal@menuscan.com',

//       appearance: 'Appearance',
//       chooseYourLook: 'Choose your look',
//       appearanceSubtitle:
//           'Pick how MenuScan appears. Your choice is saved automatically and applies across all screens.',
//       themeMode: 'Theme Mode',
//       systemDefaultSubtitle: 'Follow your device\'s light/dark setting',
//       lightSubtitle: 'Bright background, easy on the eyes in daylight',
//       darkSubtitle: 'Dim background, easier on the eyes at night',
//       preview: 'Preview',
//       sampleMenuItem: 'Sample Menu Item',
//       sampleMenuItemDesc:
//           'Grilled chicken with seasonal vegetables and a light lemon sauce.',
//       primary: 'Primary',
//       secondary: 'Secondary',
//       systemDefaultInfo:
//           'System Default automatically switches between light and dark based on your device\'s time and settings.',

//       notAuthenticated: 'Not authenticated',
//       passwordMin8: 'Password must be at least 8 characters',
//       newPasswordsDoNotMatch: 'New passwords do not match',

//       deleteAccountConfirm:
//           'This action cannot be undone. Are you sure you want to delete your account permanently?',
//       deleteMyAccount: 'Delete My Account',
//       yourAccountHasBeenDeleted: 'Your account has been deleted.',
//       failedToDeleteAccount: 'Failed to delete account.',
//       notLoggedIn: 'You are not logged in.',

//       feedback: 'Feedback',
//       shareFeedback: 'Share your feedback',
//       feedbackIntro:
//           'Help us improve MenuScan. Report a bug, suggest a feature, or just tell us what you think.',
//       feedbackType: 'Feedback Type',
//       bugReport: 'Bug Report',
//       featureRequest: 'Feature Request',
//       generalFeedback: 'General Feedback',
//       feedbackMessage: 'Your message...',
//       submit: 'Submit',
//       submitting: 'Submitting...',
//       feedbackSubmitted: 'Thank you! Your feedback has been submitted.',
//       feedbackFailed: 'Failed to submit feedback. Please try again.',
//       pleaseEnterMessage: 'Please enter a message before submitting.',

//       loading: 'Loading...',
//       error: 'Error',
//       success: 'Success',
//       ok: 'OK',
//       yes: 'Yes',
//       no: 'No',
//       back: 'Back',
//     ),

//     // ====================================================================
//     // ============================== SPANISH =============================
//     // ====================================================================
//     'es': AppStrings(
//       settings: 'Ajustes',
//       language: 'Idioma',
//       chooseLanguage: 'Elegir idioma',
//       scanQrCode: 'Escanear código QR',
//       scanToViewMenu: 'Escanea para ver el menú y pedir al instante',
//       nearbyRestaurants: 'Negocios cercanos',
//       popularCategories: 'Categorías populares',
//       offers: 'Ofertas',
//       seeAll: 'Ver todo',
//       searchRestaurants: 'Buscar negocios por nombre...',
//       getDirections: 'Obtener indicaciones',
//       menu: 'Productos y artículos',
//       noMenuAvailable: 'Menú no disponible',
//       home: 'Inicio',
//       discover: 'Descubrir',
//       events: 'Publicaciones',
//       profile: 'Perfil',
//       restaurants: 'Negocios',
//       filtered: 'Filtrado',
//       byDistance: 'Por distancia',
//       byReviews: 'Por reseñas',
//       noRestaurantsFound: 'No se encontraron negocios',
//       noCategoriesAvailable: 'No hay categorías disponibles',
//       searchRestaurantsOrPlaces: 'Buscar negocios o lugares...',
//       searchDishesOrRestaurants: 'Buscar platos o negocios...',
//       reviews: 'reseñas',
//       closed: 'Cerrado',
//       discoverFoods: 'Descubrir comidas',
//       topRated: 'Negocios mejor valorados',
//       nearby: 'Negocios cercanos',
//       noDishesFound: 'No se encontraron platos',
//       close: 'Cerrar',

//       scanQrTitle: 'Escanear código QR',
//       pointCameraAtQr: 'Apunta la cámara al código QR de la mesa',
//       loadingMenu: 'Cargando menú...',
//       invalidQr: 'Código QR inválido. Escanea un QR de menú de negocio.',
//       couldNotLoadMenu:
//           'No se pudo cargar el menú. Asegúrate de que el backend esté en ejecución.',
//       couldNotOpenMaps: 'No se pudo abrir Google Maps',

//       open: 'Abierto',
//       noName: 'Sin nombre',
//       noLocation: 'Sin ubicación',
//       noDescription: 'Sin descripción',
//       description: 'Descripción',
//       addToCart: 'Añadir al carrito',
//       addedToCart: 'Añadido al carrito',

//       welcomeBack: '¡Bienvenido de nuevo!',
//       loginSubtitle:
//           'Inicia sesión en tu cuenta para continuar\npidiendo y gestionando tu menú.',
//       username: 'Nombre de usuario',
//       password: 'Contraseña',
//       rememberMe: 'Recuérdame',
//       forgotPassword: '¿Olvidaste tu contraseña?',
//       logIn: 'Iniciar sesión',
//       or: 'o',
//       continueWithGoogle: 'Continuar con Google',
//       dontHaveAccount: '¿No tienes una cuenta? ',
//       signUp: 'Registrarse',
//       createAccount: 'Crear cuenta',
//       signupSubtitle:
//           'Regístrate para empezar a explorar y\ngestionar tus negocios favoritos.',
//       fullNameHint: 'Nombre completo',
//       emailAddress: 'Correo electrónico',
//       emailHint: 'Correo',
//       confirmPassword: 'Confirmar contraseña',
//       agreeToTerms: 'Acepto los ',
//       and: ' y la ',
//       privacyPolicy: 'Política de privacidad',
//       alreadyHaveAccount: '¿Ya tienes una cuenta? ',
//       loginSuccessfully: 'Sesión iniciada correctamente',
//       loginFailed:
//           'Verifica tu conexión a internet o usuario/contraseña incorrectos',
//       pleaseEnterUsernameAndPassword:
//           'Por favor, introduce usuario y contraseña',
//       anErrorOccurred: 'Ocurrió un error. Inténtalo de nuevo.',
//       failedToGetIdToken: 'No se pudo obtener el token de Google.',
//       googleLoginFailed: 'Error al iniciar sesión con Google.',
//       somethingWentWrong: 'Algo salió mal. Inténtalo de nuevo.',
//       googleSignUpComingSoon: '¡Registro con Google próximamente!',

//       pleaseEnterFullName: 'Por favor, introduce tu nombre completo',
//       pleaseEnterValidEmail: 'Por favor, introduce un correo válido',
//       pleaseEnterValidPhone: 'Por favor, introduce un teléfono válido',
//       passwordMin6: 'La contraseña debe tener al menos 6 caracteres',
//       passwordsDoNotMatch: 'Las contraseñas no coinciden',
//       pleaseAgreeToTerms: 'Por favor, acepta los Términos y Condiciones',
//       accountCreatedSuccessfully: '¡Cuenta creada correctamente!',
//       registrationFailed: 'Registro fallido',
//       networkError: 'Error de red. Verifica tu conexión.',
//       connectionError: 'Error de conexión. Inténtalo de nuevo.',

//       createProfile: 'Crear perfil',
//       createProfileSubtitle:
//           'Completa tu perfil para empezar\ny conectar con negocios increíbles.',
//       enterFullName: 'Introduce tu nombre completo',
//       enterEmail: 'Introduce tu correo electrónico',
//       enterPhone: 'Introduce tu número de teléfono',
//       enterLocation: 'Introduce tu ubicación',
//       selectBirthDate: 'Selecciona tu fecha de nacimiento',
//       tellUsAboutYourself: 'Cuéntanos sobre ti',
//       bio: 'Biografía',
//       birthDate: 'Fecha de nacimiento',
//       location: 'Ubicación',
//       skipForNow: 'Omitir por ahora',
//       saveChanges: 'Guardar cambios',
//       profileCreatedSuccessfully: '¡Perfil creado correctamente!',
//       tapPhotoToChange: 'Toca la foto para cambiarla',
//       nameCannotBeEmpty: 'El nombre no puede estar vacío',
//       enterValidEmail: 'Introduce un correo válido',

//       profileId: 'ID de perfil',
//       activity: 'Actividad',
//       birthday: 'Cumpleaños',
//       about: 'Acerca de',
//       contactInformation: 'Información de contacto',
//       notSet: 'No establecido',
//       message: 'Mensaje',
//       edit: 'Editar',
//       retry: 'Reintentar',
//       messageComingSoon: 'Función de mensajes próximamente',

//       account: 'Cuenta',
//       editProfile: 'Editar perfil',
//       updatePersonalInfo: 'Actualiza tu información personal',
//       changePassword: 'Cambiar contraseña',
//       updateYourPassword: 'Actualiza tu contraseña',
//       emailSettings: 'Configuración de correo',
//       manageEmailPreferences: 'Administrar preferencias de correo',
//       login: 'Iniciar sesión',
//       signInToYourAccount: 'Inicia sesión en tu cuenta',
//       register: 'Registrarse',
//       createNewAccount: 'Crear una nueva cuenta',
//       preferences: 'Preferencias',
//       notifications: 'Notificaciones',
//       pushNotifications: 'Notificaciones push',
//       theme: 'Tema',
//       darkMode: 'Modo oscuro',
//       support: 'Soporte',
//       helpSupport: 'Ayuda y soporte',
//       getHelpWithMenuScan: 'Obtén ayuda con MenuScan',
//       sendFeedback: 'Enviar comentarios',
//       helpUsImprove: 'Ayúdanos a mejorar',
//       version: 'Versión 1.0.0',
//       accountManagement: 'Gestión de cuenta',
//       logout: 'Cerrar sesión',
//       signOutOfYourAccount: 'Cierra sesión de tu cuenta',
//       deleteAccount: 'Eliminar cuenta',
//       permanentlyDeleteYourAccount: 'Eliminar tu cuenta permanentemente',
//       active: 'Activo',
//       user: 'Usuario',
//       email: 'Correo',
//       loggedOutSuccessfully: 'Sesión cerrada correctamente',
//       areYouSureYouWantToLogout: '¿Seguro que quieres cerrar sesión?',
//       cancel: 'Cancelar',
//       delete: 'Eliminar',
//       thisActionCannotBeUndone:
//           'Esta acción no se puede deshacer. ¿Seguro que quieres eliminar tu cuenta permanentemente?',
//       fullName: 'Nombre completo',
//       phoneNumber: 'Número de teléfono',
//       save: 'Guardar',
//       saving: 'Guardando...',
//       profileUpdatedSuccessfully: 'Perfil actualizado correctamente',
//       currentPassword: 'Contraseña actual',
//       newPassword: 'Nueva contraseña',
//       confirmNewPassword: 'Confirmar nueva contraseña',
//       updatePassword: 'Actualizar contraseña',
//       passwordChangedSuccessfully: 'Contraseña cambiada correctamente',
//       pleaseEnterYourName: 'Por favor, introduce tu nombre',
//       pleaseEnterYourEmail: 'Por favor, introduce tu correo',
//       pleaseEnterYourCurrentPassword:
//           'Por favor, introduce tu contraseña actual',
//       pleaseEnterANewPassword: 'Por favor, introduce una nueva contraseña',
//       passwordMustBeAtLeast6Characters:
//           'La contraseña debe tener al menos 6 caracteres',
//       pleaseConfirmYourNewPassword: 'Por favor, confirma tu nueva contraseña',
//       emailNotifications: 'Notificaciones por correo',
//       orderUpdates: 'Actualizaciones de pedidos',
//       dark: 'Oscuro',
//       light: 'Claro',
//       systemDefault: 'Predeterminado del sistema',
//       english: 'Inglés',
//       spanish: 'Español',
//       french: 'Francés',
//       arabic: 'Árabe',
//       korean: 'Coreano',
//       japanese: 'Japonés',
//       chinese: 'Chino',

//       howCanWeHelpYou: '¿Cómo podemos ayudarte?',
//       findQuickAnswers:
//           'Encuentra respuestas rápidas a continuación o contáctanos directamente — normalmente respondemos en 1–2 días hábiles.',
//       frequentlyAskedQuestions: 'Preguntas frecuentes',
//       faqHowDoIScanAMenu: '¿Cómo escaneo un menú?',
//       faqHowDoIScanAMenuAnswer:
//           'Abre la app, toca el botón de escaneo en la pantalla de inicio y apunta la cámara al código QR del negocio. El menú digital se cargará automáticamente — sin descargas.',
//       faqDoINeedAccount: '¿Necesito una cuenta para usar MenuScan?',
//       faqDoINeedAccountAnswer:
//           'Puedes explorar menús como invitado. Solo se necesita una cuenta para guardar platos favoritos, enviar comentarios o sincronizar entre dispositivos.',
//       faqWhyNoMenuLoading: '¿Por qué no se carga un menú?',
//       faqWhyNoMenuLoadingAnswer:
//           'Comprueba primero tu conexión a internet. Si el código QR es antiguo o el negocio no ha actualizado su menú, pide al personal un código nuevo. También puedes reportar el problema desde la pantalla del menú.',
//       faqSaveFavorite: '¿Cómo guardo un plato en favoritos?',
//       faqSaveFavoriteAnswer:
//           'Toca el icono del corazón junto a cualquier plato mientras ves un menú. Los platos guardados aparecen en Perfil → Favoritos.',
//       faqIsDataSafe: '¿Están seguros mis datos?',
//       faqIsDataSafeAnswer:
//           'Sí. Nunca almacenamos datos de pago y tus escaneos no se comparten con terceros. Consulta nuestra Política de privacidad para más detalles.',
//       contactSupport: 'Contacto y soporte',
//       emailSupport: 'Soporte por correo',
//       emailSupportSubtitle: 'support@menuscan.com — responde en 1–2 días',
//       reportProblem: 'Reportar un problema',
//       reportProblemSubtitle:
//           '¿Encontraste un error? Envíanos los detalles y lo arreglaremos rápido.',
//       suggestFeature: 'Sugerir una función',
//       suggestFeatureSubtitle: 'Cuéntanos qué haría MenuScan mejor para ti.',
//       rateApp: 'Calificar la app',
//       rateAppSubtitle: '¿Disfrutas MenuScan? Una reseña nos ayuda mucho.',
//       madeWithLove: 'MenuScan v1.0.0  •  Hecho con ❤️',
//       yourFeedbackShapes:
//           'Tus comentarios moldean directamente lo que construimos después. Ya sea un error, una función faltante o una pequeña idea — leemos cada mensaje.',
//       greatReportIncludes: 'Un buen informe incluye:',
//       tipWhatYouWereDoing: 'Qué estabas haciendo',
//       tipWhatYouExpected: 'Qué esperabas que ocurriera',
//       tipWhatActuallyHappened: 'Qué ocurrió realmente',
//       tipIdeasForImproving: 'Ideas para mejorar la app',
//       shareYourFeedback: 'Comparte tus comentarios...',
//       submitFeedback: 'Enviar comentarios',
//       loginToSendFeedback: 'Inicia sesión para enviar comentarios',
//       pleaseEnterFeedback:
//           'Por favor, introduce tus comentarios antes de enviar.',
//       feedbackSentThanks: '¡Comentarios enviados! ¡Gracias!',
//       failedToSendFeedback:
//           'No se pudieron enviar los comentarios. Inténtalo de nuevo más tarde.',
//       foodDeliveryApp: 'App de entrega de comida',

//       searchPosts: 'Buscar publicaciones...',
//       searchPostsOrPlaces: 'Buscar publicaciones o lugares...',
//       byDate: 'Por fecha',
//       byPopularity: 'Por popularidad',
//       noPostsFound: 'No se encontraron publicaciones',
//       errorLoadingPosts: 'Error al cargar publicaciones',
//       errorLoadingMore: 'Error al cargar más',
//       failedToLoadPosts: 'No se pudieron cargar las publicaciones',
//       failedToToggleLike: 'No se pudo cambiar el "me gusta"',
//       failedToSharePost: 'No se pudo compartir la publicación',
//       userNotAuthenticated:
//           'Usuario no autenticado. Inicia sesión primero.',
//       unknownErrorOccurred: 'Ocurrió un error desconocido',
//       checkOutThisPost: '¡Mira esta publicación!',
//       checkOut: 'Mira:',
//       like: 'Me gusta',
//       likes: 'Me gusta',
//       comment: 'Comentar',
//       comments: 'Comentarios',
//       share: 'Compartir',
//       shares: 'Compartidos',
//       showMore: 'Ver más',
//       showLess: 'Ver menos',
//       date: 'Fecha',
//       time: 'Hora',
//       organizer: 'Organizador',
//       sideBar: 'Menú lateral',
//       post: 'Publicación',
//       integrateQrHint: 'Integra tu paquete mobile_scanner aquí',

//       aboutTitle: 'Acerca de',
//       digitalMenus: 'Menús digitales',
//       digitalMenusSubtitle:
//           'Escanea códigos QR para explorar menús al instante',
//       fastScanning: 'Escaneo rápido',
//       fastScanningSubtitle: 'Escáner integrado para acceso rápido',
//       savedEvents: 'Publicaciones guardadas',
//       savedEventsSubtitle: 'Publicaciones que guardaste',
//       shareMenus: 'Compartir menús',
//       shareMenusSubtitle: 'Envía menús a amigos y familiares',
//       rateUs: 'Califícanos',
//       madeWithLoveBy: 'Hecho con ❤️ por el equipo de MenuScan',
//       allRightsReserved: '© 2025 MenuScan. Todos los derechos reservados.',

//       weAreHereToHelp: 'Estamos aquí para ayudarte',
//       contactSupportSubtitle:
//           'Elige el canal que mejor se adapte a tu pregunta. Respondemos a la mayoría de los mensajes en 1–2 días hábiles.',
//       reachUs: 'Contáctanos',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: 'Preguntas generales y ayuda con la cuenta',
//       reportBug: 'Reportar un error',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: 'Caídas, fallos o menús rotos',
//       privacyInquiries: 'Consultas de privacidad',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: 'Acceso a datos, eliminación o inquietudes',
//       legal: 'Legal',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: 'Términos, licencias, marcas registradas',
//       beforeYouWrite: 'Antes de escribir',
//       includeTheseDetails: 'Incluye estos detalles para que podamos ayudar más rápido:',
//       yourAccountEmail: 'Correo de tu cuenta (si aplica)',
//       appVersion: 'Versión de la app (Ajustes → Acerca de)',
//       deviceAndOs: 'Dispositivo y SO (ej., Pixel 7, Android 14)',
//       stepsToReproduce: 'Pasos para reproducir el problema',
//       screenshots: 'Capturas de pantalla o grabación',
//       responseTimes: 'Tiempos de respuesta',
//       generalInquiries: 'Consultas generales',
//       bugReports: 'Reportes de errores',
//       privacyRequests: 'Solicitudes de privacidad',
//       criticalIssues: 'Problemas críticos',
//       followUs: 'Síguenos',
//       website: 'Sitio web',
//       twitter: 'Twitter',
//       instagram: 'Instagram',
//       sendInAppFeedback: 'Enviar comentarios desde la app',
//       weReadEveryMessage:
//           'Leemos cada mensaje. Gracias por ayudarnos a mejorar.',

//       yourPrivacyMatters: 'Tu privacidad importa',
//       privacyIntro:
//           'Esta política explica qué datos recopila MenuScan, por qué los recopilamos y cómo mantienes el control. Lenguaje claro, sin trucos legales.',
//       lastUpdated: 'Última actualización: enero 2025',
//       informationWeCollect: 'Información que recopilamos',
//       informationWeCollectBody:
//           'Solo recopilamos lo necesario para operar MenuScan:\n\n• Datos de cuenta — correo y usuario al registrarte.\n• Datos de uso — qué menús escaneas, platos vistos y fallos de la app (anonimizados).\n• Datos del dispositivo — versión del SO y de la app, usados para corregir errores.\n• Comentarios — todo lo que nos envíes voluntariamente.',
//       howWeUseYourData: 'Cómo usamos tus datos',
//       howWeUseYourDataBody:
//           'Tus datos se usan para:\n\n• Mostrarte menús digitales desde códigos QR escaneados.\n• Sincronizar tus favoritos entre dispositivos.\n• Mejorar el rendimiento y corregir errores.\n• Responder a tus solicitudes de soporte.\n\nNunca vendemos tus datos a anunciantes ni terceros.',
//       sharingThirdParties: 'Compartir y terceros',
//       sharingThirdPartiesBody:
//           'Solo compartimos datos con proveedores esenciales (hosting, analítica, reporte de fallos) bajo contratos estrictos. No compartimos datos personales con negocios ni marketers sin tu consentimiento explícito.',
//       dataRetention: 'Retención de datos',
//       dataRetentionBody:
//           'Los datos de la cuenta se mantienen mientras tu cuenta esté activa. Los datos de uso anónimos se conservan hasta 12 meses. Los comentarios se almacenan hasta su resolución más 6 meses. Puedes solicitar la eliminación en cualquier momento.',
//       yourRights: 'Tus derechos',
//       yourRightsBody:
//           'Tienes derecho a:\n\n• Acceder a una copia de tus datos.\n• Corregir información inexacta.\n• Eliminar tu cuenta y datos asociados.\n• Optar por no participar en analíticas no esenciales.\n\nPara ejercer cualquiera de estos, escribe a privacy@menuscan.com.',
//       cookiesTracking: 'Cookies y seguimiento',
//       cookiesTrackingBody:
//           'La app móvil no usa cookies. La analítica se limita al seguimiento anonimizado de eventos que se puede desactivar en Ajustes → Privacidad.',
//       childrensPrivacy: 'Privacidad de menores',
//       childrensPrivacyBody:
//           'MenuScan no está destinado a menores de 13 años. No recopilamos datos de menores a sabiendas. Si crees que un menor ha proporcionado datos, contáctanos para su eliminación inmediata.',
//       changesToThisPolicy: 'Cambios a esta política',
//       changesToThisPolicyBody:
//           'Te notificaremos en la app antes de que cualquier cambio material entre en vigor. El uso continuado después de esa fecha significa que aceptas la política actualizada.',
//       contactUs: 'Contáctanos',
//       contactUsBody:
//           '¿Preguntas sobre privacidad? Escríbenos a:\n\nCorreo: privacy@menuscan.com\nTiempo de respuesta: 1–2 días hábiles.',

//       termsOfService: 'Términos de servicio',
//       rulesOfUsing: 'Las reglas de uso de MenuScan',
//       termsIntro:
//           'Al descargar o usar MenuScan, aceptas estos términos. Por favor léelos — definen qué puedes esperar de nosotros y qué esperamos de ti.',
//       effective: 'Vigente: enero 2025',
//       acceptanceOfTerms: '1. Aceptación de los términos',
//       acceptanceOfTermsBody:
//           'Al crear una cuenta o usar MenuScan, confirmas que tienes al menos 13 años y aceptas estos términos. Si no estás de acuerdo, por favor no uses la app.',
//       yourAccount: '2. Tu cuenta',
//       yourAccountBody:
//           'Eres responsable de:\n\n• Mantener seguras tus credenciales de inicio de sesión.\n• Toda actividad que ocurra bajo tu cuenta.\n• Notificarnos inmediatamente cualquier uso no autorizado.\n\nPodemos suspender cuentas que violen estos términos.',
//       acceptableUse: '3. Uso aceptable',
//       acceptableUseBody:
//           'Aceptas NO:\n\n• Realizar ingeniería inversa, copiar o revender la app.\n• Subir código malicioso o intentar interrumpir el servicio.\n• Extraer menús o datos de usuarios sin permiso.\n• Enviar contenido falso, abusivo o ilegal a través de comentarios.\n\nLas violaciones pueden resultar en la terminación permanente de la cuenta.',
//       menuContent: '4. Contenido del menú',
//       menuContentBody:
//           'Los datos del menú son proporcionados por los negocios. Aunque trabajamos para mantener la información precisa, no garantizamos precios, alérgenos ni disponibilidad. Confirma siempre con el personal del negocio antes de pedir, especialmente por alergias.',
//       intellectualProperty: '5. Propiedad intelectual',
//       intellectualPropertyBody:
//           'El nombre MenuScan, el logo y el código de la app son nuestros. El contenido del menú pertenece a los respectivos negocios. No puedes usar nuestra marca sin permiso escrito.',
//       serviceAvailability: '6. Disponibilidad del servicio',
//       serviceAvailabilityBody:
//           'Aspiramos a un 99% de disponibilidad pero no garantizamos un servicio ininterrumpido. Podemos suspender temporalmente el acceso por mantenimiento, actualizaciones o razones fuera de nuestro control.',
//       limitationOfLiability: '7. Limitación de responsabilidad',
//       limitationOfLiabilityBody:
//           'MenuScan se proporciona "tal cual". Hasta el máximo permitido por la ley, no somos responsables de daños indirectos derivados del uso de la app, incluida información incorrecta del menú.',
//       termination: '8. Terminación',
//       terminationBody:
//           'Puedes eliminar tu cuenta en cualquier momento desde Ajustes. Podemos terminar o suspender el acceso si se violan estos términos, con o sin aviso.',
//       changesToTerms: '9. Cambios a los términos',
//       changesToTermsBody:
//           'Podemos actualizar estos términos ocasionalmente. Los cambios significativos se anunciarán en la app. El uso continuado después de los cambios significa que aceptas los nuevos términos.',
//       contact: '10. Contacto',
//       contactBody:
//           '¿Preguntas sobre estos términos?\n\nCorreo: legal@menuscan.com',

//       appearance: 'Apariencia',
//       chooseYourLook: 'Elige tu estilo',
//       appearanceSubtitle:
//           'Elige cómo aparece MenuScan. Tu elección se guarda automáticamente y se aplica en todas las pantallas.',
//       themeMode: 'Modo de tema',
//       systemDefaultSubtitle: 'Sigue el ajuste claro/oscuro de tu dispositivo',
//       lightSubtitle: 'Fondo claro, fácil para la vista durante el día',
//       darkSubtitle: 'Fondo oscuro, más suave para la vista de noche',
//       preview: 'Vista previa',
//       sampleMenuItem: 'Elemento de menú de ejemplo',
//       sampleMenuItemDesc:
//           'Pollo a la parrilla con verduras de temporada y una ligera salsa de limón.',
//       primary: 'Primario',
//       secondary: 'Secundario',
//       systemDefaultInfo:
//           'El predeterminado del sistema cambia automáticamente entre claro y oscuro según la hora y los ajustes de tu dispositivo.',

//       notAuthenticated: 'No autenticado',
//       passwordMin8: 'La contraseña debe tener al menos 8 caracteres',
//       newPasswordsDoNotMatch: 'Las nuevas contraseñas no coinciden',

//       deleteAccountConfirm:
//           'Esta acción no se puede deshacer. ¿Seguro que quieres eliminar tu cuenta permanentemente?',
//       deleteMyAccount: 'Eliminar mi cuenta',
//       yourAccountHasBeenDeleted: 'Tu cuenta ha sido eliminada.',
//       failedToDeleteAccount: 'No se pudo eliminar la cuenta.',
//       notLoggedIn: 'No has iniciado sesión.',

//       feedback: 'Comentarios',
//       shareFeedback: 'Comparte tus comentarios',
//       feedbackIntro:
//           'Ayúdanos a mejorar MenuScan. Reporta un error, sugiere una función o simplemente dinos qué piensas.',
//       feedbackType: 'Tipo de comentario',
//       bugReport: 'Reporte de error',
//       featureRequest: 'Solicitud de función',
//       generalFeedback: 'Comentario general',
//       feedbackMessage: 'Tu mensaje...',
//       submit: 'Enviar',
//       submitting: 'Enviando...',
//       feedbackSubmitted: '¡Gracias! Tus comentarios han sido enviados.',
//       feedbackFailed:
//           'No se pudieron enviar los comentarios. Inténtalo de nuevo.',
//       pleaseEnterMessage: 'Por favor, introduce un mensaje antes de enviar.',

//       loading: 'Cargando...',
//       error: 'Error',
//       success: 'Éxito',
//       ok: 'OK',
//       yes: 'Sí',
//       no: 'No',
//       back: 'Atrás',
//     ),

//     // ====================================================================
//     // ============================== FRENCH ==============================
//     // ====================================================================
//     'fr': AppStrings(
//       settings: 'Paramètres',
//       language: 'Langue',
//       chooseLanguage: 'Choisir la langue',
//       scanQrCode: 'Scanner le code QR',
//       scanToViewMenu: 'Scannez pour voir le menu et commander',
//       nearbyRestaurants: 'Entreprises à proximité',
//       popularCategories: 'Catégories populaires',
//       offers: 'Offres',
//       seeAll: 'Voir tout',
//       searchRestaurants: 'Rechercher des entreprises par nom...',
//       getDirections: 'Itinéraire',
//       menu: 'Produits et articles',
//       noMenuAvailable: 'Menu indisponible',
//       home: 'Accueil',
//       discover: 'Découvrir',
//       events: 'Publications',
//       profile: 'Profil',
//       restaurants: 'Entreprises',
//       filtered: 'Filtré',
//       byDistance: 'Par distance',
//       byReviews: 'Par avis',
//       noRestaurantsFound: 'Aucune entreprise trouvée',
//       noCategoriesAvailable: 'Aucune catégorie disponible',
//       searchRestaurantsOrPlaces:
//           'Rechercher des entreprises ou lieux...',
//       searchDishesOrRestaurants: 'Rechercher des plats ou entreprises...',
//       reviews: 'avis',
//       closed: 'Fermé',
//       discoverFoods: 'Découvrir les plats',
//       topRated: 'Entreprises les mieux notées',
//       nearby: 'Entreprises à proximité',
//       noDishesFound: 'Aucun plat trouvé',
//       close: 'Fermer',

//       scanQrTitle: 'Scanner le code QR',
//       pointCameraAtQr: 'Pointez la caméra vers le code QR sur la table',
//       loadingMenu: 'Chargement du menu...',
//       invalidQr:
//           'Code QR invalide. Scannez un QR de menu d\'entreprise.',
//       couldNotLoadMenu:
//           'Impossible de charger le menu. Vérifiez que le backend est en marche.',
//       couldNotOpenMaps: 'Impossible d\'ouvrir Google Maps',

//       open: 'Ouvert',
//       noName: 'Sans nom',
//       noLocation: 'Sans localisation',
//       noDescription: 'Sans description',
//       description: 'Description',
//       addToCart: 'Ajouter au panier',
//       addedToCart: 'Ajouté au panier',

//       welcomeBack: 'Bon retour !',
//       loginSubtitle:
//           'Connectez-vous à votre compte pour continuer\nà commander et gérer votre menu.',
//       username: 'Nom d\'utilisateur',
//       password: 'Mot de passe',
//       rememberMe: 'Se souvenir de moi',
//       forgotPassword: 'Mot de passe oublié ?',
//       logIn: 'Se connecter',
//       or: 'ou',
//       continueWithGoogle: 'Continuer avec Google',
//       dontHaveAccount: 'Vous n\'avez pas de compte ? ',
//       signUp: 'S\'inscrire',
//       createAccount: 'Créer un compte',
//       signupSubtitle:
//           'Inscrivez-vous pour commencer à explorer et\ngérer vos entreprises préférées.',
//       fullNameHint: 'Nom complet',
//       emailAddress: 'Adresse e-mail',
//       emailHint: 'E-mail',
//       confirmPassword: 'Confirmer le mot de passe',
//       agreeToTerms: 'J\'accepte les ',
//       and: ' et la ',
//       privacyPolicy: 'Politique de confidentialité',
//       alreadyHaveAccount: 'Vous avez déjà un compte ? ',
//       loginSuccessfully: 'Connexion réussie',
//       loginFailed:
//           'Vérifiez votre connexion Internet ou votre identifiant/mot de passe',
//       pleaseEnterUsernameAndPassword:
//           'Veuillez saisir le nom d\'utilisateur et le mot de passe',
//       anErrorOccurred: 'Une erreur s\'est produite. Réessayez.',
//       failedToGetIdToken: 'Échec de l\'obtention du jeton Google.',
//       googleLoginFailed: 'Échec de la connexion Google.',
//       somethingWentWrong: 'Quelque chose s\'est mal passé. Réessayez.',
//       googleSignUpComingSoon: 'Inscription Google bientôt disponible !',

//       pleaseEnterFullName: 'Veuillez saisir votre nom complet',
//       pleaseEnterValidEmail: 'Veuillez saisir un e-mail valide',
//       pleaseEnterValidPhone: 'Veuillez saisir un numéro valide',
//       passwordMin6: 'Le mot de passe doit comporter au moins 6 caractères',
//       passwordsDoNotMatch: 'Les mots de passe ne correspondent pas',
//       pleaseAgreeToTerms:
//           'Veuillez accepter les Termes et Conditions',
//       accountCreatedSuccessfully: 'Compte créé avec succès !',
//       registrationFailed: 'Échec de l\'inscription',
//       networkError: 'Erreur réseau. Vérifiez votre connexion.',
//       connectionError: 'Erreur de connexion. Réessayez.',

//       createProfile: 'Créer un profil',
//       createProfileSubtitle:
//           'Complétez votre profil pour commencer\net vous connecter à des entreprises incroyables.',
//       enterFullName: 'Saisissez votre nom complet',
//       enterEmail: 'Saisissez votre adresse e-mail',
//       enterPhone: 'Saisissez votre numéro de téléphone',
//       enterLocation: 'Saisissez votre localisation',
//       selectBirthDate: 'Sélectionnez votre date de naissance',
//       tellUsAboutYourself: 'Parlez-nous de vous',
//       bio: 'Bio',
//       birthDate: 'Date de naissance',
//       location: 'Localisation',
//       skipForNow: 'Passer pour l\'instant',
//       saveChanges: 'Enregistrer les modifications',
//       profileCreatedSuccessfully: 'Profil créé avec succès !',
//       tapPhotoToChange: 'Appuyez sur la photo pour la changer',
//       nameCannotBeEmpty: 'Le nom ne peut pas être vide',
//       enterValidEmail: 'Saisissez un e-mail valide',

//       profileId: 'ID du profil',
//       activity: 'Activité',
//       birthday: 'Anniversaire',
//       about: 'À propos',
//       contactInformation: 'Coordonnées',
//       notSet: 'Non défini',
//       message: 'Message',
//       edit: 'Modifier',
//       retry: 'Réessayer',
//       messageComingSoon: 'Fonction message bientôt disponible',

//       account: 'Compte',
//       editProfile: 'Modifier le profil',
//       updatePersonalInfo: 'Mettez à jour vos informations personnelles',
//       changePassword: 'Changer le mot de passe',
//       updateYourPassword: 'Mettez à jour votre mot de passe',
//       emailSettings: 'Paramètres e-mail',
//       manageEmailPreferences: 'Gérer les préférences e-mail',
//       login: 'Connexion',
//       signInToYourAccount: 'Connectez-vous à votre compte',
//       register: 'S\'inscrire',
//       createNewAccount: 'Créer un nouveau compte',
//       preferences: 'Préférences',
//       notifications: 'Notifications',
//       pushNotifications: 'Notifications push',
//       theme: 'Thème',
//       darkMode: 'Mode sombre',
//       support: 'Support',
//       helpSupport: 'Aide et support',
//       getHelpWithMenuScan: 'Obtenez de l\'aide avec MenuScan',
//       sendFeedback: 'Envoyer un commentaire',
//       helpUsImprove: 'Aidez-nous à améliorer',
//       version: 'Version 1.0.0',
//       accountManagement: 'Gestion du compte',
//       logout: 'Déconnexion',
//       signOutOfYourAccount: 'Déconnectez-vous de votre compte',
//       deleteAccount: 'Supprimer le compte',
//       permanentlyDeleteYourAccount: 'Supprimer définitivement votre compte',
//       active: 'Actif',
//       user: 'Utilisateur',
//       email: 'E-mail',
//       loggedOutSuccessfully: 'Déconnexion réussie',
//       areYouSureYouWantToLogout:
//           'Êtes-vous sûr de vouloir vous déconnecter ?',
//       cancel: 'Annuler',
//       delete: 'Supprimer',
//       thisActionCannotBeUndone:
//           'Cette action est irréversible. Êtes-vous sûr de vouloir supprimer définitivement votre compte ?',
//       fullName: 'Nom complet',
//       phoneNumber: 'Numéro de téléphone',
//       save: 'Enregistrer',
//       saving: 'Enregistrement...',
//       profileUpdatedSuccessfully: 'Profil mis à jour avec succès',
//       currentPassword: 'Mot de passe actuel',
//       newPassword: 'Nouveau mot de passe',
//       confirmNewPassword: 'Confirmer le nouveau mot de passe',
//       updatePassword: 'Mettre à jour le mot de passe',
//       passwordChangedSuccessfully: 'Mot de passe modifié avec succès',
//       pleaseEnterYourName: 'Veuillez saisir votre nom',
//       pleaseEnterYourEmail: 'Veuillez saisir votre e-mail',
//       pleaseEnterYourCurrentPassword:
//           'Veuillez saisir votre mot de passe actuel',
//       pleaseEnterANewPassword: 'Veuillez saisir un nouveau mot de passe',
//       passwordMustBeAtLeast6Characters:
//           'Le mot de passe doit comporter au moins 6 caractères',
//       pleaseConfirmYourNewPassword:
//           'Veuillez confirmer votre nouveau mot de passe',
//       emailNotifications: 'Notifications par e-mail',
//       orderUpdates: 'Mises à jour des commandes',
//       dark: 'Sombre',
//       light: 'Clair',
//       systemDefault: 'Par défaut du système',
//       english: 'Anglais',
//       spanish: 'Espagnol',
//       french: 'Français',
//       arabic: 'Arabe',
//       korean: 'Coréen',
//       japanese: 'Japonais',
//       chinese: 'Chinois',

//       howCanWeHelpYou: 'Comment pouvons-nous vous aider ?',
//       findQuickAnswers:
//           'Trouvez des réponses rapides ci-dessous, ou contactez-nous directement — nous répondons généralement sous 1 à 2 jours ouvrables.',
//       frequentlyAskedQuestions: 'Questions fréquentes',
//       faqHowDoIScanAMenu: 'Comment scanner un menu ?',
//       faqHowDoIScanAMenuAnswer:
//           'Ouvrez l\'application, appuyez sur le bouton de scan sur l\'écran d\'accueil, et pointez votre caméra vers le code QR de l\'entreprise. Le menu numérique se chargera automatiquement — aucun téléchargement nécessaire.',
//       faqDoINeedAccount: 'Ai-je besoin d\'un compte pour utiliser MenuScan ?',
//       faqDoINeedAccountAnswer:
//           'Vous pouvez parcourir les menus en tant qu\'invité. Un compte n\'est requis que pour enregistrer des plats favoris, envoyer des commentaires ou synchroniser entre appareils.',
//       faqWhyNoMenuLoading: 'Pourquoi un menu ne se charge-t-il pas ?',
//       faqWhyNoMenuLoadingAnswer:
//           'Vérifiez d\'abord votre connexion internet. Si le code QR est ancien ou si l\'entreprise n\'a pas mis à jour son menu, demandez un nouveau code au personnel. Vous pouvez aussi signaler le problème depuis l\'écran du menu.',
//       faqSaveFavorite: 'Comment enregistrer un plat en favori ?',
//       faqSaveFavoriteAnswer:
//           'Appuyez sur l\'icône cœur à côté d\'un plat lorsque vous consultez un menu. Les plats enregistrés apparaissent sous Profil → Favoris.',
//       faqIsDataSafe: 'Mes données sont-elles en sécurité ?',
//       faqIsDataSafeAnswer:
//           'Oui. Nous ne stockons jamais de données de paiement et vos scans ne sont pas partagés avec des tiers. Voir notre Politique de confidentialité pour plus de détails.',
//       contactSupport: 'Contact et support',
//       emailSupport: 'Support par e-mail',
//       emailSupportSubtitle: 'support@menuscan.com — réponse en 1–2 jours',
//       reportProblem: 'Signaler un problème',
//       reportProblemSubtitle:
//           'Vous avez trouvé un bug ? Envoyez-nous les détails et nous le corrigerons rapidement.',
//       suggestFeature: 'Suggérer une fonctionnalité',
//       suggestFeatureSubtitle:
//           'Dites-nous ce qui rendrait MenuScan meilleur pour vous.',
//       rateApp: 'Noter l\'application',
//       rateAppSubtitle:
//           'Vous aimez MenuScan ? Un avis nous aide beaucoup.',
//       madeWithLove: 'MenuScan v1.0.0  •  Fait avec ❤️',
//       yourFeedbackShapes:
//           'Vos commentaires façonnent directement ce que nous construisons ensuite. Qu\'il s\'agisse d\'un bug, d\'une fonctionnalité manquante ou d\'une petite idée — nous lisons chaque message.',
//       greatReportIncludes: 'Un bon rapport comprend :',
//       tipWhatYouWereDoing: 'Ce que vous faisiez',
//       tipWhatYouExpected: 'Ce à quoi vous vous attendiez',
//       tipWhatActuallyHappened: 'Ce qui s\'est réellement passé',
//       tipIdeasForImproving: 'Des idées pour améliorer l\'application',
//       shareYourFeedback: 'Partagez vos commentaires...',
//       submitFeedback: 'Envoyer le commentaire',
//       loginToSendFeedback: 'Connectez-vous pour envoyer un commentaire',
//       pleaseEnterFeedback:
//           'Veuillez saisir vos commentaires avant de soumettre.',
//       feedbackSentThanks: 'Commentaire envoyé ! Merci !',
//       failedToSendFeedback:
//           'Échec de l\'envoi du commentaire. Réessayez plus tard.',
//       foodDeliveryApp: 'Application de livraison de nourriture',

//       searchPosts: 'Rechercher des publications...',
//       searchPostsOrPlaces: 'Rechercher des publications ou lieux...',
//       byDate: 'Par date',
//       byPopularity: 'Par popularité',
//       noPostsFound: 'Aucune publication trouvée',
//       errorLoadingPosts: 'Erreur de chargement des publications',
//       errorLoadingMore: 'Erreur de chargement supplémentaire',
//       failedToLoadPosts: 'Échec du chargement des publications',
//       failedToToggleLike: 'Échec du changement de "j\'aime"',
//       failedToSharePost: 'Échec du partage de la publication',
//       userNotAuthenticated:
//           'Utilisateur non authentifié. Connectez-vous d\'abord.',
//       unknownErrorOccurred: 'Une erreur inconnue s\'est produite',
//       checkOutThisPost: 'Découvrez cette publication !',
//       checkOut: 'Découvrez :',
//       like: 'J\'aime',
//       likes: 'J\'aime',
//       comment: 'Commenter',
//       comments: 'Commentaires',
//       share: 'Partager',
//       shares: 'Partages',
//       showMore: 'Voir plus',
//       showLess: 'Voir moins',
//       date: 'Date',
//       time: 'Heure',
//       organizer: 'Organisateur',
//       sideBar: 'Barre latérale',
//       post: 'Publication',
//       integrateQrHint: 'Intégrez votre package mobile_scanner ici',

//       aboutTitle: 'À propos',
//       digitalMenus: 'Menus numériques',
//       digitalMenusSubtitle:
//           'Scannez les codes QR pour parcourir les menus instantanément',
//       fastScanning: 'Scan rapide',
//       fastScanningSubtitle: 'Scanner intégré pour un accès rapide',
//       savedEvents: 'Publications enregistrées',
//       savedEventsSubtitle: 'Publications que vous avez mises en favori',
//       shareMenus: 'Partager les menus',
//       shareMenusSubtitle: 'Envoyez des menus à vos amis et à votre famille',
//       rateUs: 'Notez-nous',
//       madeWithLoveBy: 'Fait avec ❤️ par l\'équipe MenuScan',
//       allRightsReserved:
//           '© 2025 MenuScan. Tous droits réservés.',

//       weAreHereToHelp: 'Nous sommes là pour vous aider',
//       contactSupportSubtitle:
//           'Choisissez le canal adapté à votre question. Nous répondons à la plupart des messages sous 1–2 jours ouvrables.',
//       reachUs: 'Nous joindre',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: 'Questions générales et aide au compte',
//       reportBug: 'Signaler un bug',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: 'Plantage, bug ou menu cassé',
//       privacyInquiries: 'Demandes de confidentialité',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: 'Accès aux données, suppression ou préoccupations',
//       legal: 'Mentions légales',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: 'Termes, licences, questions de marque',
//       beforeYouWrite: 'Avant d\'écrire',
//       includeTheseDetails:
//           'Incluez ces détails pour que nous puissions aider plus rapidement :',
//       yourAccountEmail: 'E-mail de votre compte (si applicable)',
//       appVersion: 'Version de l\'app (Paramètres → À propos)',
//       deviceAndOs: 'Appareil et OS (ex., Pixel 7, Android 14)',
//       stepsToReproduce: 'Étapes pour reproduire le problème',
//       screenshots: 'Captures d\'écran ou enregistrement',
//       responseTimes: 'Délais de réponse',
//       generalInquiries: 'Demandes générales',
//       bugReports: 'Rapports de bugs',
//       privacyRequests: 'Demandes de confidentialité',
//       criticalIssues: 'Problèmes critiques',
//       followUs: 'Suivez-nous',
//       website: 'Site web',
//       twitter: 'Twitter',
//       instagram: 'Instagram',
//       sendInAppFeedback: 'Envoyer un commentaire depuis l\'app',
//       weReadEveryMessage:
//           'Nous lisons chaque message. Merci de nous aider à nous améliorer.',

//       yourPrivacyMatters: 'Votre vie privée compte',
//       privacyIntro:
//           'Cette politique explique quelles données MenuScan collecte, pourquoi nous les collectons, et comment vous gardez le contrôle. Langage clair, sans astuces juridiques.',
//       lastUpdated: 'Dernière mise à jour : janvier 2025',
//       informationWeCollect: 'Informations que nous collectons',
//       informationWeCollectBody:
//           'Nous ne collectons que ce qui est nécessaire pour faire fonctionner MenuScan :\n\n• Données de compte — e-mail et nom d\'utilisateur lors de l\'inscription.\n• Données d\'utilisation — quels menus vous scannez, plats consultés et plantages de l\'app (anonymisés).\n• Données de l\'appareil — version de l\'OS et de l\'app, utilisées pour corriger les bugs.\n• Commentaires — tout ce que vous nous envoyez volontairement.',
//       howWeUseYourData: 'Comment nous utilisons vos données',
//       howWeUseYourDataBody:
//           'Vos données sont utilisées pour :\n\n• Vous montrer des menus numériques à partir des codes QR scannés.\n• Synchroniser vos favoris entre appareils.\n• Améliorer les performances de l\'app et corriger les bugs.\n• Répondre à vos demandes de support.\n\nNous ne vendons jamais vos données aux annonceurs ou à des tiers.',
//       sharingThirdParties: 'Partage et tiers',
//       sharingThirdPartiesBody:
//           'Nous ne partageons des données qu\'avec des fournisseurs de services essentiels (hébergement, analyse, rapports de plantage) sous contrats stricts. Nous ne partageons pas de données personnelles avec des entreprises ou des marketeurs sans votre consentement explicite.',
//       dataRetention: 'Conservation des données',
//       dataRetentionBody:
//           'Les données de compte sont conservées tant que votre compte est actif. Les données d\'utilisation anonymes sont conservées jusqu\'à 12 mois. Les commentaires sont stockés jusqu\'à résolution plus 6 mois. Vous pouvez demander la suppression à tout moment.',
//       yourRights: 'Vos droits',
//       yourRightsBody:
//           'Vous avez le droit de :\n\n• Accéder à une copie de vos données.\n• Corriger les informations inexactes.\n• Supprimer votre compte et les données associées.\n• Refuser les analyses non essentielles.\n\nPour exercer l\'un de ces droits, écrivez à privacy@menuscan.com.',
//       cookiesTracking: 'Cookies et suivi',
//       cookiesTrackingBody:
//           'L\'application mobile n\'utilise pas de cookies. L\'analyse se limite au suivi d\'événements anonymisés qui peut être désactivé dans Paramètres → Confidentialité.',
//       childrensPrivacy: 'Confidentialité des enfants',
//       childrensPrivacyBody:
//           'MenuScan n\'est pas destiné aux enfants de moins de 13 ans. Nous ne collectons pas sciemment de données auprès d\'enfants. Si vous pensez qu\'un enfant a fourni des données, contactez-nous pour un retrait immédiat.',
//       changesToThisPolicy: 'Modifications de cette politique',
//       changesToThisPolicyBody:
//           'Nous vous informerons dans l\'app avant que tout changement important ne prenne effet. L\'utilisation continue après cette date signifie que vous acceptez la politique mise à jour.',
//       contactUs: 'Nous contacter',
//       contactUsBody:
//           'Des questions sur la confidentialité ? Écrivez-nous à :\n\nE-mail : privacy@menuscan.com\nDélai de réponse : 1–2 jours ouvrables.',

//       termsOfService: 'Conditions d\'utilisation',
//       rulesOfUsing: 'Les règles d\'utilisation de MenuScan',
//       termsIntro:
//           'En téléchargeant ou utilisant MenuScan, vous acceptez ces conditions. Veuillez les lire — elles définissent ce que vous pouvez attendre de nous, et ce que nous attendons de vous.',
//       effective: 'En vigueur : janvier 2025',
//       acceptanceOfTerms: '1. Acceptation des conditions',
//       acceptanceOfTermsBody:
//           'En créant un compte ou en utilisant MenuScan, vous confirmez avoir au moins 13 ans et accepter ces conditions. Si vous n\'êtes pas d\'accord, veuillez ne pas utiliser l\'app.',
//       yourAccount: '2. Votre compte',
//       yourAccountBody:
//           'Vous êtes responsable de :\n\n• Garder vos identifiants de connexion sécurisés.\n• Toute activité survenant sous votre compte.\n• Nous notifier immédiatement toute utilisation non autorisée.\n\nNous pouvons suspendre les comptes qui violent ces conditions.',
//       acceptableUse: '3. Utilisation acceptable',
//       acceptableUseBody:
//           'Vous acceptez de NE PAS :\n\n• Faire de l\'ingénierie inverse, copier ou revendre l\'app.\n• Télécharger du code malveillant ou tenter de perturber le service.\n• Extraire des menus ou des données utilisateur sans permission.\n• Soumettre du contenu faux, abusif ou illégal via les commentaires.\n\nLes violations peuvent entraîner la résiliation permanente du compte.',
//       menuContent: '4. Contenu du menu',
//       menuContentBody:
//           'Les données du menu sont fournies par les entreprises. Bien que nous travaillions à maintenir l\'information exacte, nous ne garantissons pas les prix, les allergènes ou la disponibilité. Confirmez toujours avec le personnel de l\'entreprise avant de commander, en particulier pour les allergies.',
//       intellectualProperty: '5. Propriété intellectuelle',
//       intellectualPropertyBody:
//           'Le nom MenuScan, le logo et le code de l\'app nous appartiennent. Le contenu du menu appartient aux entreprises respectives. Vous ne pouvez pas utiliser notre image de marque sans autorisation écrite.',
//       serviceAvailability: '6. Disponibilité du service',
//       serviceAvailabilityBody:
//           'Nous visons 99% de disponibilité mais ne garantissons pas un service ininterrompu. Nous pouvons suspendre temporairement l\'accès pour maintenance, mises à jour ou raisons hors de notre contrôle.',
//       limitationOfLiability: '7. Limitation de responsabilité',
//       limitationOfLiabilityBody:
//           'MenuScan est fourni « tel quel ». Dans la mesure maximale permise par la loi, nous ne sommes pas responsables des dommages indirects résultant de votre utilisation de l\'app, y compris les informations de menu incorrectes.',
//       termination: '8. Résiliation',
//       terminationBody:
//           'Vous pouvez supprimer votre compte à tout moment depuis les Paramètres. Nous pouvons résilier ou suspendre l\'accès si ces conditions sont violées, avec ou sans préavis.',
//       changesToTerms: '9. Modifications des conditions',
//       changesToTermsBody:
//           'Nous pouvons mettre à jour ces conditions occasionnellement. Les changements importants seront annoncés dans l\'app. L\'utilisation continue après les changements signifie que vous acceptez les nouvelles conditions.',
//       contact: '10. Contact',
//       contactBody:
//           'Des questions sur ces conditions ?\n\nE-mail : legal@menuscan.com',

//       appearance: 'Apparence',
//       chooseYourLook: 'Choisissez votre style',
//       appearanceSubtitle:
//           'Choisissez l\'apparence de MenuScan. Votre choix est enregistré automatiquement et s\'applique à tous les écrans.',
//       themeMode: 'Mode de thème',
//       systemDefaultSubtitle:
//           'Suit le réglage clair/sombre de votre appareil',
//       lightSubtitle: 'Fond clair, reposant en journée',
//       darkSubtitle: 'Fond sombre, plus doux pour les yeux la nuit',
//       preview: 'Aperçu',
//       sampleMenuItem: 'Exemple d\'élément de menu',
//       sampleMenuItemDesc:
//           'Poulet grillé avec légumes de saison et une sauce légère au citron.',
//       primary: 'Principal',
//       secondary: 'Secondaire',
//       systemDefaultInfo:
//           'Le mode par défaut du système bascule automatiquement entre clair et sombre selon l\'heure et les paramètres de votre appareil.',

//       notAuthenticated: 'Non authentifié',
//       passwordMin8: 'Le mot de passe doit comporter au moins 8 caractères',
//       newPasswordsDoNotMatch:
//           'Les nouveaux mots de passe ne correspondent pas',

//       deleteAccountConfirm:
//           'Cette action est irréversible. Êtes-vous sûr de vouloir supprimer définitivement votre compte ?',
//       deleteMyAccount: 'Supprimer mon compte',
//       yourAccountHasBeenDeleted: 'Votre compte a été supprimé.',
//       failedToDeleteAccount: 'Échec de la suppression du compte.',
//       notLoggedIn: 'Vous n\'êtes pas connecté.',

//       feedback: 'Commentaires',
//       shareFeedback: 'Partagez vos commentaires',
//       feedbackIntro:
//           'Aidez-nous à améliorer MenuScan. Signalez un bug, suggérez une fonctionnalité ou dites-nous ce que vous pensez.',
//       feedbackType: 'Type de commentaire',
//       bugReport: 'Rapport de bug',
//       featureRequest: 'Demande de fonctionnalité',
//       generalFeedback: 'Commentaire général',
//       feedbackMessage: 'Votre message...',
//       submit: 'Envoyer',
//       submitting: 'Envoi...',
//       feedbackSubmitted: 'Merci ! Votre commentaire a été envoyé.',
//       feedbackFailed:
//           'Échec de l\'envoi du commentaire. Réessayez.',
//       pleaseEnterMessage:
//           'Veuillez saisir un message avant d\'envoyer.',

//       loading: 'Chargement...',
//       error: 'Erreur',
//       success: 'Succès',
//       ok: 'OK',
//       yes: 'Oui',
//       no: 'Non',
//       back: 'Retour',
//     ),

//     // ====================================================================
//     // ============================== ARABIC ==============================
//     // ====================================================================
//     'ar': AppStrings(
//       settings: 'الإعدادات',
//       language: 'اللغة',
//       chooseLanguage: 'اختر اللغة',
//       scanQrCode: 'مسح رمز QR',
//       scanToViewMenu: 'امسح لعرض القائمة والطلب فورًا',
//       nearbyRestaurants: 'الشركات القريبة',
//       popularCategories: 'الفئات الشائعة',
//       offers: 'العروض',
//       seeAll: 'عرض الكل',
//       searchRestaurants: 'ابحث عن الشركات بالاسم...',
//       getDirections: 'احصل على الاتجاهات',
//       menu: 'المنتجات والعناصر',
//       noMenuAvailable: 'القائمة غير متوفرة',
//       home: 'الرئيسية',
//       discover: 'استكشف',
//       events: 'المنشورات',
//       profile: 'الملف الشخصي',
//       restaurants: 'الشركات',
//       filtered: 'مُصفّى',
//       byDistance: 'حسب المسافة',
//       byReviews: 'حسب التقييمات',
//       noRestaurantsFound: 'لم يتم العثور على شركات',
//       noCategoriesAvailable: 'لا توجد فئات متاحة',
//       searchRestaurantsOrPlaces: 'ابحث عن الشركات أو الأماكن...',
//       searchDishesOrRestaurants: 'ابحث عن الأطباق أو الشركات...',
//       reviews: 'تقييمات',
//       closed: 'مغلق',
//       discoverFoods: 'اكتشف الأطباق',
//       topRated: 'الشركات الأعلى تقييماً',
//       nearby: 'الشركات القريبة',
//       noDishesFound: 'لم يتم العثور على أطباق',
//       close: 'إغلاق',

//       scanQrTitle: 'مسح رمز QR',
//       pointCameraAtQr: 'وجّه الكاميرا نحو رمز QR على الطاولة',
//       loadingMenu: 'جارٍ تحميل القائمة...',
//       invalidQr: 'رمز QR غير صالح. يرجى مسح رمز قائمة شركة.',
//       couldNotLoadMenu: 'تعذّر تحميل القائمة. تأكد من تشغيل الخادم.',
//       couldNotOpenMaps: 'تعذّر فتح خرائط جوجل',

//       open: 'مفتوح',
//       noName: 'بلا اسم',
//       noLocation: 'بلا موقع',
//       noDescription: 'بلا وصف',
//       description: 'الوصف',
//       addToCart: 'أضف إلى السلة',
//       addedToCart: 'أُضيف إلى السلة',

//       welcomeBack: 'مرحبًا بعودتك!',
//       loginSubtitle:
//           'سجّل الدخول إلى حسابك للمتابعة\nفي الطلب وإدارة قائمتك.',
//       username: 'اسم المستخدم',
//       password: 'كلمة المرور',
//       rememberMe: 'تذكرني',
//       forgotPassword: 'نسيت كلمة المرور؟',
//       logIn: 'تسجيل الدخول',
//       or: 'أو',
//       continueWithGoogle: 'المتابعة باستخدام Google',
//       dontHaveAccount: 'ليس لديك حساب؟ ',
//       signUp: 'التسجيل',
//       createAccount: 'إنشاء حساب',
//       signupSubtitle:
//           'سجّل لتبدأ في استكشاف وإدارة\nشركاتك المفضلة.',
//       fullNameHint: 'الاسم الكامل',
//       emailAddress: 'البريد الإلكتروني',
//       emailHint: 'البريد',
//       confirmPassword: 'تأكيد كلمة المرور',
//       agreeToTerms: 'أوافق على ',
//       and: ' و',
//       privacyPolicy: 'سياسة الخصوصية',
//       alreadyHaveAccount: 'لديك حساب بالفعل؟ ',
//       loginSuccessfully: 'تم تسجيل الدخول بنجاح',
//       loginFailed:
//           'تحقق من اتصالك بالإنترنت أو اسم المستخدم وكلمة المرور',
//       pleaseEnterUsernameAndPassword:
//           'الرجاء إدخال اسم المستخدم وكلمة المرور',
//       anErrorOccurred: 'حدث خطأ. يرجى المحاولة مرة أخرى.',
//       failedToGetIdToken: 'فشل الحصول على رمز Google.',
//       googleLoginFailed: 'فشل تسجيل الدخول عبر Google.',
//       somethingWentWrong: 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
//       googleSignUpComingSoon: 'التسجيل عبر Google قريبًا!',

//       pleaseEnterFullName: 'الرجاء إدخال اسمك الكامل',
//       pleaseEnterValidEmail: 'الرجاء إدخال بريد إلكتروني صالح',
//       pleaseEnterValidPhone: 'الرجاء إدخال رقم هاتف صالح',
//       passwordMin6: 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
//       passwordsDoNotMatch: 'كلمتا المرور غير متطابقتين',
//       pleaseAgreeToTerms: 'الرجاء الموافقة على الشروط والأحكام',
//       accountCreatedSuccessfully: 'تم إنشاء الحساب بنجاح!',
//       registrationFailed: 'فشل التسجيل',
//       networkError: 'خطأ في الشبكة. تحقق من اتصالك.',
//       connectionError: 'خطأ في الاتصال. يرجى المحاولة مرة أخرى.',

//       createProfile: 'إنشاء الملف الشخصي',
//       createProfileSubtitle:
//           'أكمل ملفك الشخصي للبدء\nوالتواصل مع شركات رائعة.',
//       enterFullName: 'أدخل اسمك الكامل',
//       enterEmail: 'أدخل بريدك الإلكتروني',
//       enterPhone: 'أدخل رقم هاتفك',
//       enterLocation: 'أدخل موقعك',
//       selectBirthDate: 'اختر تاريخ ميلادك',
//       tellUsAboutYourself: 'أخبرنا عن نفسك',
//       bio: 'نبذة',
//       birthDate: 'تاريخ الميلاد',
//       location: 'الموقع',
//       skipForNow: 'تخطَّ الآن',
//       saveChanges: 'حفظ التغييرات',
//       profileCreatedSuccessfully: 'تم إنشاء الملف الشخصي بنجاح!',
//       tapPhotoToChange: 'اضغط على الصورة لتغييرها',
//       nameCannotBeEmpty: 'لا يمكن أن يكون الاسم فارغًا',
//       enterValidEmail: 'أدخل بريدًا إلكترونيًا صالحًا',

//       profileId: 'معرّف الملف الشخصي',
//       activity: 'النشاط',
//       birthday: 'عيد الميلاد',
//       about: 'حول',
//       contactInformation: 'معلومات الاتصال',
//       notSet: 'غير محدد',
//       message: 'رسالة',
//       edit: 'تعديل',
//       retry: 'إعادة المحاولة',
//       messageComingSoon: 'ميزة الرسائل قريبًا',

//       account: 'الحساب',
//       editProfile: 'تعديل الملف الشخصي',
//       updatePersonalInfo: 'حدّث معلوماتك الشخصية',
//       changePassword: 'تغيير كلمة المرور',
//       updateYourPassword: 'حدّث كلمة المرور',
//       emailSettings: 'إعدادات البريد الإلكتروني',
//       manageEmailPreferences: 'إدارة تفضيلات البريد الإلكتروني',
//       login: 'تسجيل الدخول',
//       signInToYourAccount: 'سجّل الدخول إلى حسابك',
//       register: 'التسجيل',
//       createNewAccount: 'إنشاء حساب جديد',
//       preferences: 'التفضيلات',
//       notifications: 'الإشعارات',
//       pushNotifications: 'الإشعارات الفورية',
//       theme: 'المظهر',
//       darkMode: 'الوضع الداكن',
//       support: 'الدعم',
//       helpSupport: 'المساعدة والدعم',
//       getHelpWithMenuScan: 'احصل على مساعدة بخصوص MenuScan',
//       sendFeedback: 'إرسال الملاحظات',
//       helpUsImprove: 'ساعدنا على التحسين',
//       version: 'الإصدار 1.0.0',
//       accountManagement: 'إدارة الحساب',
//       logout: 'تسجيل الخروج',
//       signOutOfYourAccount: 'اخرج من حسابك',
//       deleteAccount: 'حذف الحساب',
//       permanentlyDeleteYourAccount: 'احذف حسابك نهائيًا',
//       active: 'نشط',
//       user: 'مستخدم',
//       email: 'البريد الإلكتروني',
//       loggedOutSuccessfully: 'تم تسجيل الخروج بنجاح',
//       areYouSureYouWantToLogout: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
//       cancel: 'إلغاء',
//       delete: 'حذف',
//       thisActionCannotBeUndone:
//           'لا يمكن التراجع عن هذا الإجراء. هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟',
//       fullName: 'الاسم الكامل',
//       phoneNumber: 'رقم الهاتف',
//       save: 'حفظ',
//       saving: 'جارٍ الحفظ...',
//       profileUpdatedSuccessfully: 'تم تحديث الملف الشخصي بنجاح',
//       currentPassword: 'كلمة المرور الحالية',
//       newPassword: 'كلمة المرور الجديدة',
//       confirmNewPassword: 'تأكيد كلمة المرور الجديدة',
//       updatePassword: 'تحديث كلمة المرور',
//       passwordChangedSuccessfully: 'تم تغيير كلمة المرور بنجاح',
//       pleaseEnterYourName: 'الرجاء إدخال اسمك',
//       pleaseEnterYourEmail: 'الرجاء إدخال بريدك الإلكتروني',
//       pleaseEnterYourCurrentPassword: 'الرجاء إدخال كلمة المرور الحالية',
//       pleaseEnterANewPassword: 'الرجاء إدخال كلمة مرور جديدة',
//       passwordMustBeAtLeast6Characters:
//           'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
//       pleaseConfirmYourNewPassword: 'الرجاء تأكيد كلمة المرور الجديدة',
//       emailNotifications: 'إشعارات البريد الإلكتروني',
//       orderUpdates: 'تحديثات الطلب',
//       dark: 'داكن',
//       light: 'فاتح',
//       systemDefault: 'افتراضي النظام',
//       english: 'الإنجليزية',
//       spanish: 'الإسبانية',
//       french: 'الفرنسية',
//       arabic: 'العربية',
//       korean: 'الكورية',
//       japanese: 'اليابانية',
//       chinese: 'الصينية',

//       howCanWeHelpYou: 'كيف يمكننا مساعدتك؟',
//       findQuickAnswers:
//           'اعثر على إجابات سريعة أدناه، أو تواصل معنا مباشرة — نرد عادةً خلال 1–2 يوم عمل.',
//       frequentlyAskedQuestions: 'الأسئلة الشائعة',
//       faqHowDoIScanAMenu: 'كيف أمسح قائمة طعام؟',
//       faqHowDoIScanAMenuAnswer:
//           'افتح التطبيق، اضغط على زر المسح في الشاشة الرئيسية، ووجّه الكاميرا إلى رمز QR الخاص بالشركة. ستُحمّل القائمة الرقمية تلقائيًا — بدون تنزيل.',
//       faqDoINeedAccount: 'هل أحتاج إلى حساب لاستخدام MenuScan؟',
//       faqDoINeedAccountAnswer:
//           'يمكنك تصفح القوائم كزائر. الحساب مطلوب فقط لحفظ الأطباق المفضلة أو إرسال الملاحظات أو المزامنة بين الأجهزة.',
//       faqWhyNoMenuLoading: 'لماذا لا تُحمَّل القائمة؟',
//       faqWhyNoMenuLoadingAnswer:
//           'تحقق أولاً من اتصالك بالإنترنت. إذا كان رمز QR قديمًا أو لم تحدّث الشركة قائمتها، اطلب من الموظفين رمزًا جديدًا. يمكنك أيضًا الإبلاغ عن المشكلة من شاشة القائمة.',
//       faqSaveFavorite: 'كيف أحفظ طبقًا في المفضلة؟',
//       faqSaveFavoriteAnswer:
//           'اضغط على أيقونة القلب بجانب أي طبق أثناء عرض القائمة. تظهر الأطباق المحفوظة تحت الملف الشخصي → المفضلة.',
//       faqIsDataSafe: 'هل بياناتي آمنة؟',
//       faqIsDataSafeAnswer:
//           'نعم. لا نخزّن بيانات الدفع أبدًا، ولا تتم مشاركة عمليات المسح مع أطراف ثالثة. راجع سياسة الخصوصية للحصول على التفاصيل الكاملة.',
//       contactSupport: 'الاتصال والدعم',
//       emailSupport: 'الدعم بالبريد الإلكتروني',
//       emailSupportSubtitle: 'support@menuscan.com — الرد خلال 1–2 يوم',
//       reportProblem: 'الإبلاغ عن مشكلة',
//       reportProblemSubtitle:
//           'وجدت خطأ؟ أرسل لنا التفاصيل وسنصلحه بسرعة.',
//       suggestFeature: 'اقترح ميزة',
//       suggestFeatureSubtitle: 'أخبرنا بما سيجعل MenuScan أفضل لك.',
//       rateApp: 'قيّم التطبيق',
//       rateAppSubtitle: 'هل تستمتع بـ MenuScan؟ تقييمك يساعدنا كثيرًا.',
//       madeWithLove: 'MenuScan v1.0.0  •  صُنع بـ ❤️',
//       yourFeedbackShapes:
//           'ملاحظاتك تشكّل مباشرة ما نبنيه بعد ذلك. سواء كان خطأً أو ميزة مفقودة أو فكرة صغيرة — نقرأ كل رسالة.',
//       greatReportIncludes: 'يتضمن التقرير الجيد:',
//       tipWhatYouWereDoing: 'ما كنت تفعله',
//       tipWhatYouExpected: 'ما توقعت حدوثه',
//       tipWhatActuallyHappened: 'ما حدث بالفعل',
//       tipIdeasForImproving: 'أفكار لتحسين التطبيق',
//       shareYourFeedback: 'شارك ملاحظاتك...',
//       submitFeedback: 'إرسال الملاحظات',
//       loginToSendFeedback: 'سجّل الدخول لإرسال الملاحظات',
//       pleaseEnterFeedback: 'الرجاء إدخال ملاحظاتك قبل الإرسال.',
//       feedbackSentThanks: 'تم إرسال الملاحظات! شكرًا!',
//       failedToSendFeedback:
//           'فشل إرسال الملاحظات. حاول مرة أخرى لاحقًا.',
//       foodDeliveryApp: 'تطبيق توصيل الطعام',

//       searchPosts: 'ابحث عن المنشورات...',
//       searchPostsOrPlaces: 'ابحث عن المنشورات أو الأماكن...',
//       byDate: 'حسب التاريخ',
//       byPopularity: 'حسب الشعبية',
//       noPostsFound: 'لم يتم العثور على منشورات',
//       errorLoadingPosts: 'خطأ في تحميل المنشورات',
//       errorLoadingMore: 'خطأ في تحميل المزيد',
//       failedToLoadPosts: 'فشل تحميل المنشورات',
//       failedToToggleLike: 'فشل تبديل الإعجاب',
//       failedToSharePost: 'فشل مشاركة المنشور',
//       userNotAuthenticated:
//           'المستخدم غير مصادق. الرجاء تسجيل الدخول أولاً.',
//       unknownErrorOccurred: 'حدث خطأ غير معروف',
//       checkOutThisPost: 'تحقق من هذا المنشور!',
//       checkOut: 'تحقق من:',
//       like: 'إعجاب',
//       likes: 'إعجابات',
//       comment: 'تعليق',
//       comments: 'تعليقات',
//       share: 'مشاركة',
//       shares: 'مشاركات',
//       showMore: 'عرض المزيد',
//       showLess: 'عرض أقل',
//       date: 'التاريخ',
//       time: 'الوقت',
//       organizer: 'المنظم',
//       sideBar: 'الشريط الجانبي',
//       post: 'منشور',
//       integrateQrHint: 'ادمج حزمة mobile_scanner هنا',

//       aboutTitle: 'حول',
//       digitalMenus: 'القوائم الرقمية',
//       digitalMenusSubtitle: 'امسح رموز QR لتصفح القوائم فورًا',
//       fastScanning: 'مسح سريع',
//       fastScanningSubtitle: 'ماسح مدمج للوصول السريع',
//       savedEvents: 'المنشورات المحفوظة',
//       savedEventsSubtitle: 'المنشورات التي حفظتها',
//       shareMenus: 'مشاركة القوائم',
//       shareMenusSubtitle: 'أرسل القوائم للأصدقاء والعائلة',
//       rateUs: 'قيّمنا',
//       madeWithLoveBy: 'صُنع بـ ❤️ من فريق MenuScan',
//       allRightsReserved: '© 2025 MenuScan. جميع الحقوق محفوظة.',

//       weAreHereToHelp: 'نحن هنا للمساعدة',
//       contactSupportSubtitle:
//           'اختر القناة التي تناسب سؤالك. نرد على معظم الرسائل خلال 1–2 يوم عمل.',
//       reachUs: 'تواصل معنا',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: 'أسئلة عامة ومساعدة الحساب',
//       reportBug: 'الإبلاغ عن خطأ',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: 'أعطال أو مشاكل أو قوائم معطلة',
//       privacyInquiries: 'استفسارات الخصوصية',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: 'الوصول إلى البيانات أو الحذف أو المخاوف',
//       legal: 'قانوني',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: 'الشروط والتراخيص والعلامات التجارية',
//       beforeYouWrite: 'قبل أن تكتب',
//       includeTheseDetails: 'أدرج هذه التفاصيل حتى نساعد بشكل أسرع:',
//       yourAccountEmail: 'البريد الإلكتروني لحسابك (إن وُجد)',
//       appVersion: 'إصدار التطبيق (الإعدادات → حول)',
//       deviceAndOs: 'الجهاز ونظام التشغيل (مثل Pixel 7، Android 14)',
//       stepsToReproduce: 'خطوات إعادة إنتاج المشكلة',
//       screenshots: 'لقطات الشاشة أو تسجيل الشاشة',
//       responseTimes: 'أوقات الاستجابة',
//       generalInquiries: 'الاستفسارات العامة',
//       bugReports: 'تقارير الأخطاء',
//       privacyRequests: 'طلبات الخصوصية',
//       criticalIssues: 'المشكلات الحرجة',
//       followUs: 'تابعنا',
//       website: 'الموقع الإلكتروني',
//       twitter: 'تويتر',
//       instagram: 'إنستغرام',
//       sendInAppFeedback: 'إرسال ملاحظات من التطبيق',
//       weReadEveryMessage:
//           'نقرأ كل رسالة. شكرًا لمساعدتنا على التحسين.',

//       yourPrivacyMatters: 'خصوصيتك تهمنا',
//       privacyIntro:
//           'توضح هذه السياسة البيانات التي يجمعها MenuScan، ولماذا نجمعها، وكيف تبقى متحكمًا. لغة واضحة، بلا حيل قانونية.',
//       lastUpdated: 'آخر تحديث: يناير 2025',
//       informationWeCollect: 'المعلومات التي نجمعها',
//       informationWeCollectBody:
//           'نجمع فقط ما يلزم لتشغيل MenuScan:\n\n• بيانات الحساب — البريد واسم المستخدم عند التسجيل.\n• بيانات الاستخدام — القوائم التي تمسحها، الأطباق التي تشاهدها، وأعطال التطبيق (مجهولة).\n• بيانات الجهاز — إصدار النظام والتطبيق، تُستخدم لإصلاح الأخطاء.\n• الملاحظات — أي شيء ترسله لنا طوعًا.',
//       howWeUseYourData: 'كيف نستخدم بياناتك',
//       howWeUseYourDataBody:
//           'تُستخدم بياناتك من أجل:\n\n• عرض القوائم الرقمية من رموز QR الممسوحة.\n• مزامنة مفضلاتك بين الأجهزة.\n• تحسين أداء التطبيق وإصلاح الأخطاء.\n• الرد على طلبات الدعم.\n\nلا نبيع بياناتك للمعلنين أو الأطراف الثالثة أبدًا.',
//       sharingThirdParties: 'المشاركة والأطراف الثالثة',
//       sharingThirdPartiesBody:
//           'نشارك البيانات فقط مع مزودي الخدمات الأساسيين (الاستضافة، التحليلات، تقارير الأعطال) بموجب عقود صارمة. لا نشارك البيانات الشخصية مع الشركات أو المسوقين دون موافقتك الصريحة.',
//       dataRetention: 'الاحتفاظ بالبيانات',
//       dataRetentionBody:
//           'يُحتفظ ببيانات الحساب ما دام حسابك نشطًا. تُحفظ بيانات الاستخدام المجهولة حتى 12 شهرًا. تُخزّن الملاحظات حتى الحل زائد 6 أشهر. يمكنك طلب الحذف في أي وقت.',
//       yourRights: 'حقوقك',
//       yourRightsBody:
//           'لديك الحق في:\n\n• الوصول إلى نسخة من بياناتك.\n• تصحيح المعلومات غير الدقيقة.\n• حذف حسابك وبياناتك المرتبطة به.\n• إلغاء التحليلات غير الأساسية.\n\nلممارسة أي من هذه الحقوق، راسلنا على privacy@menuscan.com.',
//       cookiesTracking: 'ملفات تعريف الارتباط والتتبع',
//       cookiesTrackingBody:
//           'لا يستخدم التطبيق ملفات تعريف الارتباط. يقتصر التحليل على تتبع الأحداث المجهول الذي يمكن تعطيله من الإعدادات → الخصوصية.',
//       childrensPrivacy: 'خصوصية الأطفال',
//       childrensPrivacyBody:
//           'MenuScan غير مخصص للأطفال تحت 13 عامًا. لا نجمع بيانات الأطفال عن قصد. إذا كنت تعتقد أن طفلاً قدّم بيانات، اتصل بنا للحذف الفوري.',
//       changesToThisPolicy: 'التغييرات على هذه السياسة',
//       changesToThisPolicyBody:
//           'سنخطرك داخل التطبيق قبل أي تغييرات جوهرية. الاستمرار في الاستخدام بعد ذلك التاريخ يعني قبولك للسياسة المحدثة.',
//       contactUs: 'اتصل بنا',
//       contactUsBody:
//           'أسئلة عن الخصوصية؟ راسلنا على:\n\nالبريد: privacy@menuscan.com\nوقت الاستجابة: 1–2 يوم عمل.',

//       termsOfService: 'شروط الخدمة',
//       rulesOfUsing: 'قواعد استخدام MenuScan',
//       termsIntro:
//           'بتنزيل أو استخدام MenuScan، أنت توافق على هذه الشروط. يرجى قراءتها — فهي تحدد ما يمكنك توقعه منا، وما نتوقعه منك.',
//       effective: 'سارية من: يناير 2025',
//       acceptanceOfTerms: '1. قبول الشروط',
//       acceptanceOfTermsBody:
//           'بإنشاء حساب أو استخدام MenuScan، تؤكد أن عمرك 13 عامًا على الأقل وتوافق على هذه الشروط. إذا لم توافق، يرجى عدم استخدام التطبيق.',
//       yourAccount: '2. حسابك',
//       yourAccountBody:
//           'أنت مسؤول عن:\n\n• الحفاظ على سرية بيانات تسجيل الدخول.\n• جميع الأنشطة التي تحدث تحت حسابك.\n• إخطارنا فورًا بأي استخدام غير مصرح به.\n\nقد نعلق الحسابات التي تنتهك هذه الشروط.',
//       acceptableUse: '3. الاستخدام المقبول',
//       acceptableUseBody:
//           'أنت توافق على عدم:\n\n• إجراء هندسة عكسية أو نسخ أو إعادة بيع التطبيق.\n• تحميل كود ضار أو محاولة تعطيل الخدمة.\n• استخراج القوائم أو بيانات المستخدمين دون إذن.\n• إرسال محتوى مزيف أو مسيء أو غير قانوني عبر الملاحظات.\n\nقد تؤدي الانتهاكات إلى إنهاء الحساب نهائيًا.',
//       menuContent: '4. محتوى القائمة',
//       menuContentBody:
//           'تُقدَّم بيانات القائمة من الشركات. بينما نعمل للحفاظ على دقة المعلومات، لا نضمن الأسعار أو مسببات الحساسية أو التوفر. تحقق دائمًا مع موظفي الشركة قبل الطلب، خاصةً للحساسية.',
//       intellectualProperty: '5. الملكية الفكرية',
//       intellectualPropertyBody:
//           'اسم MenuScan وشعاره وكود التطبيق مملوكة لنا. محتوى القائمة يخص الشركات المعنية. لا يجوز استخدام علامتنا التجارية دون إذن كتابي.',
//       serviceAvailability: '6. توفر الخدمة',
//       serviceAvailabilityBody:
//           'نهدف إلى 99% من وقت التشغيل لكننا لا نضمن خدمة غير منقطعة. قد نوقف الوصول مؤقتًا للصيانة أو التحديثات أو لأسباب خارجة عن إرادتنا.',
//       limitationOfLiability: '7. حدود المسؤولية',
//       limitationOfLiabilityBody:
//           'يُقدَّم MenuScan «كما هو». إلى أقصى حد يسمح به القانون، لسنا مسؤولين عن الأضرار غير المباشرة الناتجة عن استخدامك للتطبيق، بما في ذلك معلومات القائمة غير الصحيحة.',
//       termination: '8. الإنهاء',
//       terminationBody:
//           'يمكنك حذف حسابك في أي وقت من الإعدادات. قد ننهي أو نعلق الوصول إذا انتُهكت هذه الشروط، بإشعار أو بدونه.',
//       changesToTerms: '9. تغييرات الشروط',
//       changesToTermsBody:
//           'قد نحدّث هذه الشروط أحيانًا. سيتم الإعلان عن التغييرات المهمة في التطبيق. الاستمرار في الاستخدام بعد التغييرات يعني قبولك للشروط الجديدة.',
//       contact: '10. الاتصال',
//       contactBody: 'أسئلة عن هذه الشروط؟\n\nالبريد: legal@menuscan.com',

//       appearance: 'المظهر',
//       chooseYourLook: 'اختر مظهرك',
//       appearanceSubtitle:
//           'اختر كيف يظهر MenuScan. يتم حفظ اختيارك تلقائيًا ويطبق على جميع الشاشات.',
//       themeMode: 'وضع المظهر',
//       systemDefaultSubtitle: 'اتبع إعداد الوضع الفاتح/الداكن لجهازك',
//       lightSubtitle: 'خلفية فاتحة، مريحة للعين في النهار',
//       darkSubtitle: 'خلفية معتمة، ألطف على العين ليلًا',
//       preview: 'معاينة',
//       sampleMenuItem: 'عنصر قائمة نموذجي',
//       sampleMenuItemDesc:
//           'دجاج مشوي مع خضار موسمية وصلصة ليمون خفيفة.',
//       primary: 'أساسي',
//       secondary: 'ثانوي',
//       systemDefaultInfo:
//           'يبدّل افتراضي النظام تلقائيًا بين الفاتح والداكن بناءً على وقت جهازك وإعداداته.',

//       notAuthenticated: 'غير مصادق',
//       passwordMin8: 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
//       newPasswordsDoNotMatch: 'كلمتا المرور الجديدتان غير متطابقتين',

//       deleteAccountConfirm:
//           'لا يمكن التراجع عن هذا الإجراء. هل أنت متأكد أنك تريد حذف حسابك نهائيًا؟',
//       deleteMyAccount: 'حذف حسابي',
//       yourAccountHasBeenDeleted: 'تم حذف حسابك.',
//       failedToDeleteAccount: 'فشل حذف الحساب.',
//       notLoggedIn: 'أنت غير مسجّل الدخول.',

//       feedback: 'الملاحظات',
//       shareFeedback: 'شارك ملاحظاتك',
//       feedbackIntro:
//           'ساعدنا على تحسين MenuScan. أبلغ عن خطأ، اقترح ميزة، أو أخبرنا برأيك.',
//       feedbackType: 'نوع الملاحظة',
//       bugReport: 'تقرير خطأ',
//       featureRequest: 'طلب ميزة',
//       generalFeedback: 'ملاحظة عامة',
//       feedbackMessage: 'رسالتك...',
//       submit: 'إرسال',
//       submitting: 'جارٍ الإرسال...',
//       feedbackSubmitted: 'شكرًا! تم إرسال ملاحظاتك.',
//       feedbackFailed: 'فشل إرسال الملاحظات. حاول مرة أخرى.',
//       pleaseEnterMessage: 'الرجاء إدخال رسالة قبل الإرسال.',

//       loading: 'جارٍ التحميل...',
//       error: 'خطأ',
//       success: 'نجاح',
//       ok: 'حسنًا',
//       yes: 'نعم',
//       no: 'لا',
//       back: 'رجوع',
//     ),

//     // ====================================================================
//     // ============================== KOREAN ==============================
//     // ====================================================================
//     'ko': AppStrings(
//       settings: '설정',
//       language: '언어',
//       chooseLanguage: '언어 선택',
//       scanQrCode: 'QR 코드 스캔',
//       scanToViewMenu: '스캔하여 메뉴 보기 및 주문',
//       nearbyRestaurants: '주변 비즈니스',
//       popularCategories: '인기 카테고리',
//       offers: '혜택',
//       seeAll: '모두 보기',
//       searchRestaurants: '이름으로 비즈니스 검색...',
//       getDirections: '길찾기',
//       menu: '제품 및 항목',
//       noMenuAvailable: '메뉴 없음',
//       home: '홈',
//       discover: '탐색',
//       events: '게시물',
//       profile: '프로필',
//       restaurants: '비즈니스',
//       filtered: '필터됨',
//       byDistance: '거리순',
//       byReviews: '리뷰순',
//       noRestaurantsFound: '비즈니스를 찾을 수 없습니다',
//       noCategoriesAvailable: '사용 가능한 카테고리가 없습니다',
//       searchRestaurantsOrPlaces: '비즈니스 또는 장소 검색...',
//       searchDishesOrRestaurants: '음식 또는 비즈니스 검색...',
//       reviews: '리뷰',
//       closed: '영업 종료',
//       discoverFoods: '음식 발견',
//       topRated: '최고 평점 비즈니스',
//       nearby: '주변 비즈니스',
//       noDishesFound: '음식을 찾을 수 없습니다',
//       close: '닫기',

//       scanQrTitle: 'QR 코드 스캔',
//       pointCameraAtQr: '테이블의 QR 코드에 카메라를 맞추세요',
//       loadingMenu: '메뉴 로딩 중...',
//       invalidQr: '잘못된 QR 코드입니다. 비즈니스 메뉴 QR을 스캔하세요.',
//       couldNotLoadMenu:
//           '메뉴를 불러올 수 없습니다. 백엔드가 실행 중인지 확인하세요.',
//       couldNotOpenMaps: 'Google 지도를 열 수 없습니다',

//       open: '영업 중',
//       noName: '이름 없음',
//       noLocation: '위치 없음',
//       noDescription: '설명 없음',
//       description: '설명',
//       addToCart: '장바구니에 추가',
//       addedToCart: '장바구니에 추가됨',

//       welcomeBack: '다시 오신 것을 환영합니다!',
//       loginSubtitle:
//           '계정에 로그인하여 계속 주문하고\n메뉴를 관리하세요.',
//       username: '사용자 이름',
//       password: '비밀번호',
//       rememberMe: '로그인 상태 유지',
//       forgotPassword: '비밀번호를 잊으셨나요?',
//       logIn: '로그인',
//       or: '또는',
//       continueWithGoogle: 'Google로 계속하기',
//       dontHaveAccount: '계정이 없으신가요? ',
//       signUp: '가입',
//       createAccount: '계정 만들기',
//       signupSubtitle:
//           '가입하여 멋진 비즈니스를 탐색하고\n관리하세요.',
//       fullNameHint: '전체 이름',
//       emailAddress: '이메일 주소',
//       emailHint: '이메일',
//       confirmPassword: '비밀번호 확인',
//       agreeToTerms: '다음에 동의합니다: ',
//       and: ' 및 ',
//       privacyPolicy: '개인정보 처리방침',
//       alreadyHaveAccount: '이미 계정이 있으신가요? ',
//       loginSuccessfully: '로그인 성공',
//       loginFailed: '인터넷 연결 또는 사용자 이름/비밀번호를 확인하세요',
//       pleaseEnterUsernameAndPassword:
//           '사용자 이름과 비밀번호를 입력하세요',
//       anErrorOccurred: '오류가 발생했습니다. 다시 시도하세요.',
//       failedToGetIdToken: 'Google ID 토큰을 가져오지 못했습니다.',
//       googleLoginFailed: 'Google 로그인 실패.',
//       somethingWentWrong: '문제가 발생했습니다. 다시 시도하세요.',
//       googleSignUpComingSoon: 'Google 가입이 곧 제공됩니다!',

//       pleaseEnterFullName: '전체 이름을 입력하세요',
//       pleaseEnterValidEmail: '유효한 이메일 주소를 입력하세요',
//       pleaseEnterValidPhone: '유효한 전화번호를 입력하세요',
//       passwordMin6: '비밀번호는 6자 이상이어야 합니다',
//       passwordsDoNotMatch: '비밀번호가 일치하지 않습니다',
//       pleaseAgreeToTerms: '약관에 동의해주세요',
//       accountCreatedSuccessfully: '계정이 생성되었습니다!',
//       registrationFailed: '가입 실패',
//       networkError: '네트워크 오류. 연결을 확인하세요.',
//       connectionError: '연결 오류. 다시 시도하세요.',

//       createProfile: '프로필 만들기',
//       createProfileSubtitle:
//           '프로필을 완성하여 시작하고\n멋진 비즈니스와 연결하세요.',
//       enterFullName: '전체 이름 입력',
//       enterEmail: '이메일 주소 입력',
//       enterPhone: '전화번호 입력',
//       enterLocation: '위치 입력',
//       selectBirthDate: '생년월일 선택',
//       tellUsAboutYourself: '자기소개',
//       bio: '소개',
//       birthDate: '생년월일',
//       location: '위치',
//       skipForNow: '나중에 하기',
//       saveChanges: '변경사항 저장',
//       profileCreatedSuccessfully: '프로필이 생성되었습니다!',
//       tapPhotoToChange: '사진을 눌러 변경하세요',
//       nameCannotBeEmpty: '이름은 비워둘 수 없습니다',
//       enterValidEmail: '유효한 이메일을 입력하세요',

//       profileId: '프로필 ID',
//       activity: '활동',
//       birthday: '생일',
//       about: '정보',
//       contactInformation: '연락처 정보',
//       notSet: '설정되지 않음',
//       message: '메시지',
//       edit: '편집',
//       retry: '다시 시도',
//       messageComingSoon: '메시지 기능 곧 제공',

//       account: '계정',
//       editProfile: '프로필 편집',
//       updatePersonalInfo: '개인 정보 업데이트',
//       changePassword: '비밀번호 변경',
//       updateYourPassword: '비밀번호 업데이트',
//       emailSettings: '이메일 설정',
//       manageEmailPreferences: '이메일 환경설정 관리',
//       login: '로그인',
//       signInToYourAccount: '계정에 로그인',
//       register: '가입',
//       createNewAccount: '새 계정 만들기',
//       preferences: '환경설정',
//       notifications: '알림',
//       pushNotifications: '푸시 알림',
//       theme: '테마',
//       darkMode: '다크 모드',
//       support: '지원',
//       helpSupport: '도움말 및 지원',
//       getHelpWithMenuScan: 'MenuScan 도움말 보기',
//       sendFeedback: '피드백 보내기',
//       helpUsImprove: '개선을 도와주세요',
//       version: '버전 1.0.0',
//       accountManagement: '계정 관리',
//       logout: '로그아웃',
//       signOutOfYourAccount: '계정에서 로그아웃',
//       deleteAccount: '계정 삭제',
//       permanentlyDeleteYourAccount: '계정을 영구적으로 삭제',
//       active: '활성',
//       user: '사용자',
//       email: '이메일',
//       loggedOutSuccessfully: '로그아웃되었습니다',
//       areYouSureYouWantToLogout: '로그아웃하시겠습니까?',
//       cancel: '취소',
//       delete: '삭제',
//       thisActionCannotBeUndone:
//           '이 작업은 되돌릴 수 없습니다. 계정을 영구적으로 삭제하시겠습니까?',
//       fullName: '전체 이름',
//       phoneNumber: '전화번호',
//       save: '저장',
//       saving: '저장 중...',
//       profileUpdatedSuccessfully: '프로필이 업데이트되었습니다',
//       currentPassword: '현재 비밀번호',
//       newPassword: '새 비밀번호',
//       confirmNewPassword: '새 비밀번호 확인',
//       updatePassword: '비밀번호 업데이트',
//       passwordChangedSuccessfully: '비밀번호가 변경되었습니다',
//       pleaseEnterYourName: '이름을 입력하세요',
//       pleaseEnterYourEmail: '이메일을 입력하세요',
//       pleaseEnterYourCurrentPassword: '현재 비밀번호를 입력하세요',
//       pleaseEnterANewPassword: '새 비밀번호를 입력하세요',
//       passwordMustBeAtLeast6Characters:
//           '비밀번호는 6자 이상이어야 합니다',
//       pleaseConfirmYourNewPassword: '새 비밀번호를 확인하세요',
//       emailNotifications: '이메일 알림',
//       orderUpdates: '주문 업데이트',
//       dark: '다크',
//       light: '라이트',
//       systemDefault: '시스템 기본값',
//       english: '영어',
//       spanish: '스페인어',
//       french: '프랑스어',
//       arabic: '아랍어',
//       korean: '한국어',
//       japanese: '일본어',
//       chinese: '중국어',

//       howCanWeHelpYou: '무엇을 도와드릴까요?',
//       findQuickAnswers:
//           '아래에서 빠른 답변을 찾거나 직접 문의하세요 — 보통 1~2 영업일 이내에 답변드립니다.',
//       frequentlyAskedQuestions: '자주 묻는 질문',
//       faqHowDoIScanAMenu: '메뉴는 어떻게 스캔하나요?',
//       faqHowDoIScanAMenuAnswer:
//           '앱을 열고 홈 화면의 스캔 버튼을 누른 뒤 카메라를 비즈니스의 QR 코드에 맞추세요. 디지털 메뉴가 자동으로 로드됩니다 — 다운로드 필요 없음.',
//       faqDoINeedAccount: 'MenuScan을 사용하려면 계정이 필요한가요?',
//       faqDoINeedAccountAnswer:
//           '게스트로 메뉴를 둘러볼 수 있습니다. 계정은 즐겨찾는 음식 저장, 피드백 보내기 또는 기기 간 동기화에만 필요합니다.',
//       faqWhyNoMenuLoading: '메뉴가 로드되지 않는 이유는 무엇인가요?',
//       faqWhyNoMenuLoadingAnswer:
//           '먼저 인터넷 연결을 확인하세요. QR 코드가 오래되었거나 비즈니스가 메뉴를 업데이트하지 않았다면 직원에게 새 코드를 요청하세요. 메뉴 화면에서 문제를 신고할 수도 있습니다.',
//       faqSaveFavorite: '음식을 즐겨찾기에 저장하려면?',
//       faqSaveFavoriteAnswer:
//           '메뉴를 보면서 음식 옆의 하트 아이콘을 누르세요. 저장된 음식은 프로필 → 즐겨찾기에 표시됩니다.',
//       faqIsDataSafe: '내 데이터는 안전한가요?',
//       faqIsDataSafeAnswer:
//           '예. 결제 데이터를 저장하지 않으며 스캔은 제3자와 공유되지 않습니다. 자세한 내용은 개인정보 처리방침을 참조하세요.',
//       contactSupport: '연락처 및 지원',
//       emailSupport: '이메일 지원',
//       emailSupportSubtitle: 'support@menuscan.com — 1~2일 내 답변',
//       reportProblem: '문제 신고',
//       reportProblemSubtitle:
//           '버그를 발견하셨나요? 세부 정보를 보내주시면 빠르게 수정하겠습니다.',
//       suggestFeature: '기능 제안',
//       suggestFeatureSubtitle:
//           'MenuScan을 더 좋게 만들 아이디어를 알려주세요.',
//       rateApp: '앱 평가',
//       rateAppSubtitle: 'MenuScan이 마음에 드시나요? 리뷰가 큰 도움이 됩니다.',
//       madeWithLove: 'MenuScan v1.0.0  •  ❤️로 제작',
//       yourFeedbackShapes:
//           '여러분의 피드백이 다음에 무엇을 만들지 직접 결정합니다. 버그, 누락된 기능, 작은 아이디어 등 — 모든 메시지를 읽습니다.',
//       greatReportIncludes: '좋은 신고에는 다음이 포함됩니다:',
//       tipWhatYouWereDoing: '무엇을 하고 있었는지',
//       tipWhatYouExpected: '무엇을 기대했는지',
//       tipWhatActuallyHappened: '실제로 무슨 일이 일어났는지',
//       tipIdeasForImproving: '앱 개선 아이디어',
//       shareYourFeedback: '피드백을 공유하세요...',
//       submitFeedback: '피드백 제출',
//       loginToSendFeedback: '피드백을 보내려면 로그인하세요',
//       pleaseEnterFeedback: '제출하기 전에 피드백을 입력하세요.',
//       feedbackSentThanks: '피드백이 전송되었습니다! 감사합니다!',
//       failedToSendFeedback:
//           '피드백 전송에 실패했습니다. 나중에 다시 시도하세요.',
//       foodDeliveryApp: '음식 배달 앱',

//       searchPosts: '게시물 검색...',
//       searchPostsOrPlaces: '게시물 또는 장소 검색...',
//       byDate: '날짜순',
//       byPopularity: '인기순',
//       noPostsFound: '게시물을 찾을 수 없습니다',
//       errorLoadingPosts: '게시물 로딩 오류',
//       errorLoadingMore: '더 불러오기 오류',
//       failedToLoadPosts: '게시물을 불러오지 못했습니다',
//       failedToToggleLike: '좋아요 전환 실패',
//       failedToSharePost: '게시물 공유 실패',
//       userNotAuthenticated:
//           '사용자가 인증되지 않았습니다. 먼저 로그인하세요.',
//       unknownErrorOccurred: '알 수 없는 오류가 발생했습니다',
//       checkOutThisPost: '이 게시물을 확인하세요!',
//       checkOut: '확인:',
//       like: '좋아요',
//       likes: '좋아요',
//       comment: '댓글',
//       comments: '댓글',
//       share: '공유',
//       shares: '공유',
//       showMore: '더 보기',
//       showLess: '접기',
//       date: '날짜',
//       time: '시간',
//       organizer: '주최자',
//       sideBar: '사이드바',
//       post: '게시물',
//       integrateQrHint: '여기에 mobile_scanner 패키지를 통합하세요',

//       aboutTitle: '정보',
//       digitalMenus: '디지털 메뉴',
//       digitalMenusSubtitle: 'QR 코드를 스캔하여 메뉴를 즉시 확인',
//       fastScanning: '빠른 스캔',
//       fastScanningSubtitle: '빠른 접근을 위한 내장 스캐너',
//       savedEvents: '저장된 게시물',
//       savedEventsSubtitle: '즐겨찾기한 게시물',
//       shareMenus: '메뉴 공유',
//       shareMenusSubtitle: '친구와 가족에게 메뉴 전송',
//       rateUs: '평가하기',
//       madeWithLoveBy: 'MenuScan 팀이 ❤️로 제작',
//       allRightsReserved: '© 2025 MenuScan. 모든 권리 보유.',

//       weAreHereToHelp: '도와드리겠습니다',
//       contactSupportSubtitle:
//           '질문에 맞는 채널을 선택하세요. 대부분의 메시지에 1~2 영업일 내에 답변드립니다.',
//       reachUs: '연락하기',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: '일반 문의 및 계정 도움',
//       reportBug: '버그 신고',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: '충돌, 결함 또는 깨진 메뉴',
//       privacyInquiries: '개인정보 문의',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: '데이터 접근, 삭제 또는 우려 사항',
//       legal: '법적',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: '약관, 라이선스, 상표 문제',
//       beforeYouWrite: '작성 전',
//       includeTheseDetails: '더 빠른 도움을 위해 다음 세부 정보를 포함하세요:',
//       yourAccountEmail: '계정 이메일 (해당되는 경우)',
//       appVersion: '앱 버전 (설정 → 정보)',
//       deviceAndOs: '기기 및 OS (예: Pixel 7, Android 14)',
//       stepsToReproduce: '문제 재현 단계',
//       screenshots: '스크린샷 또는 화면 녹화',
//       responseTimes: '응답 시간',
//       generalInquiries: '일반 문의',
//       bugReports: '버그 신고',
//       privacyRequests: '개인정보 요청',
//       criticalIssues: '심각한 문제',
//       followUs: '팔로우',
//       website: '웹사이트',
//       twitter: '트위터',
//       instagram: '인스타그램',
//       sendInAppFeedback: '앱 내 피드백 보내기',
//       weReadEveryMessage:
//           '모든 메시지를 읽습니다. 개선을 도와주셔서 감사합니다.',

//       yourPrivacyMatters: '개인정보가 중요합니다',
//       privacyIntro:
//           '이 정책은 MenuScan이 수집하는 데이터, 수집 이유, 그리고 통제 방법을 설명합니다. 명확한 언어, 법적 속임수 없음.',
//       lastUpdated: '최종 업데이트: 2025년 1월',
//       informationWeCollect: '수집하는 정보',
//       informationWeCollectBody:
//           'MenuScan 운영에 필요한 것만 수집합니다:\n\n• 계정 데이터 — 가입 시 이메일과 사용자 이름.\n• 사용 데이터 — 스캔한 메뉴, 본 음식, 앱 충돌 (익명).\n• 기기 데이터 — OS 버전과 앱 버전, 버그 수정에 사용.\n• 피드백 — 자발적으로 보내주신 모든 것.',
//       howWeUseYourData: '데이터 사용 방법',
//       howWeUseYourDataBody:
//           '귀하의 데이터는 다음에 사용됩니다:\n\n• 스캔한 QR 코드에서 디지털 메뉴 표시.\n• 기기 간 즐겨찾기 동기화.\n• 앱 성능 개선 및 버그 수정.\n• 지원 요청 응답.\n\n광고주나 제3자에게 데이터를 판매하지 않습니다.',
//       sharingThirdParties: '공유 및 제3자',
//       sharingThirdPartiesBody:
//           '엄격한 계약 하에 필수 서비스 제공자(호스팅, 분석, 충돌 보고)와만 데이터를 공유합니다. 명시적 동의 없이 비즈니스나 마케터와 개인 데이터를 공유하지 않습니다.',
//       dataRetention: '데이터 보존',
//       dataRetentionBody:
//           '계정 데이터는 계정이 활성 상태인 동안 유지됩니다. 익명 사용 데이터는 최대 12개월 보존됩니다. 피드백은 해결 후 6개월까지 저장됩니다. 언제든지 삭제를 요청할 수 있습니다.',
//       yourRights: '귀하의 권리',
//       yourRightsBody:
//           '귀하는 다음 권리가 있습니다:\n\n• 데이터 사본에 접근.\n• 부정확한 정보 수정.\n• 계정 및 관련 데이터 삭제.\n• 비필수 분석 거부.\n\n이 중 하나를 행사하려면 privacy@menuscan.com으로 이메일을 보내주세요.',
//       cookiesTracking: '쿠키 및 추적',
//       cookiesTrackingBody:
//           '모바일 앱은 쿠키를 사용하지 않습니다. 분석은 설정 → 개인정보에서 비활성화할 수 있는 익명 이벤트 추적에 국한됩니다.',
//       childrensPrivacy: '아동 개인정보',
//       childrensPrivacyBody:
//           'MenuScan은 13세 미만 아동을 대상으로 하지 않습니다. 아동의 데이터를 고의로 수집하지 않습니다. 아동이 데이터를 제공했다고 생각되면 즉시 삭제를 위해 문의하세요.',
//       changesToThisPolicy: '이 정책의 변경',
//       changesToThisPolicyBody:
//           '중요한 변경이 시행되기 전에 앱 내에서 알려드립니다. 해당 날짜 이후 계속 사용하면 업데이트된 정책에 동의하는 것으로 간주됩니다.',
//       contactUs: '문의하기',
//       contactUsBody:
//           '개인정보에 대한 질문이 있으신가요? 다음으로 연락주세요:\n\n이메일: privacy@menuscan.com\n응답 시간: 1~2 영업일.',

//       termsOfService: '서비스 약관',
//       rulesOfUsing: 'MenuScan 사용 규칙',
//       termsIntro:
//           'MenuScan을 다운로드하거나 사용함으로써 이 약관에 동의합니다. 읽어주세요 — 우리에게 기대할 수 있는 것과 우리가 기대하는 것을 정의합니다.',
//       effective: '시행: 2025년 1월',
//       acceptanceOfTerms: '1. 약관 동의',
//       acceptanceOfTermsBody:
//           '계정을 만들거나 MenuScan을 사용함으로써 최소 13세 이상이며 이 약관에 동의함을 확인합니다. 동의하지 않으면 앱을 사용하지 마세요.',
//       yourAccount: '2. 귀하의 계정',
//       yourAccountBody:
//           '귀하는 다음에 책임이 있습니다:\n\n• 로그인 자격 증명을 안전하게 유지.\n• 계정에서 발생하는 모든 활동.\n• 무단 사용을 즉시 알림.\n\n이 약관을 위반하는 계정은 정지될 수 있습니다.',
//       acceptableUse: '3. 허용되는 사용',
//       acceptableUseBody:
//           '귀하는 다음을 하지 않기로 동의합니다:\n\n• 앱을 역설계, 복사 또는 재판매.\n• 악성 코드 업로드 또는 서비스 방해 시도.\n• 허가 없이 메뉴 또는 사용자 데이터 스크래핑.\n• 피드백을 통해 거짓, 모욕적 또는 불법 콘텐츠 제출.\n\n위반은 계정 영구 종료로 이어질 수 있습니다.',
//       menuContent: '4. 메뉴 콘텐츠',
//       menuContentBody:
//           '메뉴 데이터는 비즈니스에서 제공합니다. 정보를 정확하게 유지하기 위해 노력하지만 가격, 알레르기 유발 물질 또는 가용성을 보장하지 않습니다. 특히 알레르기의 경우 주문 전에 항상 비즈니스 직원에게 확인하세요.',
//       intellectualProperty: '5. 지적 재산권',
//       intellectualPropertyBody:
//           'MenuScan 이름, 로고 및 앱 코드는 당사가 소유합니다. 메뉴 콘텐츠는 해당 비즈니스에 속합니다. 서면 허가 없이 당사 브랜드를 사용할 수 없습니다.',
//       serviceAvailability: '6. 서비스 가용성',
//       serviceAvailabilityBody:
//           '99% 가동 시간을 목표로 하지만 중단 없는 서비스를 보장하지 않습니다. 유지 관리, 업데이트 또는 통제할 수 없는 이유로 일시적으로 액세스를 중단할 수 있습니다.',
//       limitationOfLiability: '7. 책임 제한',
//       limitationOfLiabilityBody:
//           'MenuScan은 "있는 그대로" 제공됩니다. 법이 허용하는 최대 범위 내에서 잘못된 메뉴 정보를 포함하여 앱 사용으로 인한 간접적 손해에 대해 책임지지 않습니다.',
//       termination: '8. 종료',
//       terminationBody:
//           '설정에서 언제든지 계정을 삭제할 수 있습니다. 이 약관이 위반되면 통지 여부와 관계없이 액세스를 종료하거나 정지할 수 있습니다.',
//       changesToTerms: '9. 약관 변경',
//       changesToTermsBody:
//           '이 약관을 가끔 업데이트할 수 있습니다. 중요한 변경은 앱 내에서 공지됩니다. 변경 후 계속 사용하면 새 약관에 동의하는 것으로 간주됩니다.',
//       contact: '10. 연락처',
//       contactBody:
//           '이 약관에 대한 질문이 있으신가요?\n\n이메일: legal@menuscan.com',

//       appearance: '모양',
//       chooseYourLook: '스타일 선택',
//       appearanceSubtitle:
//           'MenuScan이 표시되는 방식을 선택하세요. 선택 사항은 자동으로 저장되며 모든 화면에 적용됩니다.',
//       themeMode: '테마 모드',
//       systemDefaultSubtitle: '기기의 라이트/다크 설정 따르기',
//       lightSubtitle: '밝은 배경, 낮에 눈이 편함',
//       darkSubtitle: '어두운 배경, 밤에 눈이 편함',
//       preview: '미리보기',
//       sampleMenuItem: '샘플 메뉴 항목',
//       sampleMenuItemDesc:
//           '제철 채소와 가벼운 레몬 소스를 곁들인 그릴 치킨.',
//       primary: '기본',
//       secondary: '보조',
//       systemDefaultInfo:
//           '시스템 기본값은 기기의 시간과 설정에 따라 라이트와 다크를 자동으로 전환합니다.',

//       notAuthenticated: '인증되지 않음',
//       passwordMin8: '비밀번호는 8자 이상이어야 합니다',
//       newPasswordsDoNotMatch: '새 비밀번호가 일치하지 않습니다',

//       deleteAccountConfirm:
//           '이 작업은 되돌릴 수 없습니다. 계정을 영구적으로 삭제하시겠습니까?',
//       deleteMyAccount: '내 계정 삭제',
//       yourAccountHasBeenDeleted: '계정이 삭제되었습니다.',
//       failedToDeleteAccount: '계정 삭제 실패.',
//       notLoggedIn: '로그인되어 있지 않습니다.',

//       feedback: '피드백',
//       shareFeedback: '피드백 공유',
//       feedbackIntro:
//           'MenuScan 개선을 도와주세요. 버그 신고, 기능 제안, 또는 의견을 알려주세요.',
//       feedbackType: '피드백 유형',
//       bugReport: '버그 신고',
//       featureRequest: '기능 요청',
//       generalFeedback: '일반 피드백',
//       feedbackMessage: '메시지...',
//       submit: '제출',
//       submitting: '제출 중...',
//       feedbackSubmitted: '감사합니다! 피드백이 제출되었습니다.',
//       feedbackFailed: '피드백 제출 실패. 다시 시도하세요.',
//       pleaseEnterMessage: '제출하기 전에 메시지를 입력하세요.',

//       loading: '로딩 중...',
//       error: '오류',
//       success: '성공',
//       ok: '확인',
//       yes: '예',
//       no: '아니오',
//       back: '뒤로',
//     ),

//     // ====================================================================
//     // ============================== JAPANESE ============================
//     // ====================================================================
//     'ja': AppStrings(
//       settings: '設定',
//       language: '言語',
//       chooseLanguage: '言語を選択',
//       scanQrCode: 'QRコードをスキャン',
//       scanToViewMenu: 'スキャンしてメニューを見る＆注文',
//       nearbyRestaurants: '近くのビジネス',
//       popularCategories: '人気のカテゴリ',
//       offers: 'オファー',
//       seeAll: 'すべて見る',
//       searchRestaurants: '名前でビジネスを検索...',
//       getDirections: '経路を取得',
//       menu: '商品・アイテム',
//       noMenuAvailable: 'メニューなし',
//       home: 'ホーム',
//       discover: '発見',
//       events: '投稿',
//       profile: 'プロフィール',
//       restaurants: 'ビジネス',
//       filtered: 'フィルター済み',
//       byDistance: '距離順',
//       byReviews: 'レビュー順',
//       noRestaurantsFound: 'ビジネスが見つかりません',
//       noCategoriesAvailable: '利用可能なカテゴリがありません',
//       searchRestaurantsOrPlaces: 'ビジネスや場所を検索...',
//       searchDishesOrRestaurants: '料理やビジネスを検索...',
//       reviews: 'レビュー',
//       closed: '閉店',
//       discoverFoods: '料理を発見',
//       topRated: '高評価ビジネス',
//       nearby: '近くのビジネス',
//       noDishesFound: '料理が見つかりません',
//       close: '閉じる',

//       scanQrTitle: 'QRコードをスキャン',
//       pointCameraAtQr: 'テーブルのQRコードにカメラを向けてください',
//       loadingMenu: 'メニューを読み込み中...',
//       invalidQr:
//           '無効なQRコードです。ビジネスのメニューQRをスキャンしてください。',
//       couldNotLoadMenu:
//           'メニューを読み込めませんでした。バックエンドが起動しているか確認してください。',
//       couldNotOpenMaps: 'Googleマップを開けませんでした',

//       open: '営業中',
//       noName: '名前なし',
//       noLocation: '場所なし',
//       noDescription: '説明なし',
//       description: '説明',
//       addToCart: 'カートに追加',
//       addedToCart: 'カートに追加しました',

//       welcomeBack: 'おかえりなさい！',
//       loginSubtitle:
//           'アカウントにログインして、注文とメニュー管理を\n続けてください。',
//       username: 'ユーザー名',
//       password: 'パスワード',
//       rememberMe: 'ログイン状態を保持',
//       forgotPassword: 'パスワードをお忘れですか？',
//       logIn: 'ログイン',
//       or: 'または',
//       continueWithGoogle: 'Googleで続行',
//       dontHaveAccount: 'アカウントをお持ちでないですか？ ',
//       signUp: '新規登録',
//       createAccount: 'アカウント作成',
//       signupSubtitle:
//           '登録して素晴らしいビジネスを探索し\n管理しましょう。',
//       fullNameHint: '氏名',
//       emailAddress: 'メールアドレス',
//       emailHint: 'メール',
//       confirmPassword: 'パスワードを確認',
//       agreeToTerms: '以下に同意します: ',
//       and: ' および ',
//       privacyPolicy: 'プライバシーポリシー',
//       alreadyHaveAccount: 'すでにアカウントをお持ちですか？ ',
//       loginSuccessfully: 'ログイン成功',
//       loginFailed:
//           'インターネット接続、またはユーザー名/パスワードを確認してください',
//       pleaseEnterUsernameAndPassword:
//           'ユーザー名とパスワードを入力してください',
//       anErrorOccurred: 'エラーが発生しました。もう一度お試しください。',
//       failedToGetIdToken: 'Google IDトークンを取得できませんでした。',
//       googleLoginFailed: 'Googleログインに失敗しました。',
//       somethingWentWrong: '問題が発生しました。もう一度お試しください。',
//       googleSignUpComingSoon: 'Google登録は近日公開予定！',

//       pleaseEnterFullName: '氏名を入力してください',
//       pleaseEnterValidEmail: '有効なメールアドレスを入力してください',
//       pleaseEnterValidPhone: '有効な電話番号を入力してください',
//       passwordMin6: 'パスワードは6文字以上である必要があります',
//       passwordsDoNotMatch: 'パスワードが一致しません',
//       pleaseAgreeToTerms: '利用規約に同意してください',
//       accountCreatedSuccessfully: 'アカウントが作成されました！',
//       registrationFailed: '登録に失敗しました',
//       networkError: 'ネットワークエラー。接続を確認してください。',
//       connectionError: '接続エラー。もう一度お試しください。',

//       createProfile: 'プロフィール作成',
//       createProfileSubtitle:
//           'プロフィールを完成させて、素晴らしい\nビジネスとつながりましょう。',
//       enterFullName: '氏名を入力',
//       enterEmail: 'メールアドレスを入力',
//       enterPhone: '電話番号を入力',
//       enterLocation: '場所を入力',
//       selectBirthDate: '生年月日を選択',
//       tellUsAboutYourself: '自己紹介',
//       bio: '自己紹介',
//       birthDate: '生年月日',
//       location: '場所',
//       skipForNow: '後で',
//       saveChanges: '変更を保存',
//       profileCreatedSuccessfully: 'プロフィールが作成されました！',
//       tapPhotoToChange: '写真をタップして変更',
//       nameCannotBeEmpty: '名前は空にできません',
//       enterValidEmail: '有効なメールを入力してください',

//       profileId: 'プロフィールID',
//       activity: 'アクティビティ',
//       birthday: '誕生日',
//       about: '情報',
//       contactInformation: '連絡先情報',
//       notSet: '未設定',
//       message: 'メッセージ',
//       edit: '編集',
//       retry: '再試行',
//       messageComingSoon: 'メッセージ機能は近日公開',

//       account: 'アカウント',
//       editProfile: 'プロフィールを編集',
//       updatePersonalInfo: '個人情報を更新',
//       changePassword: 'パスワードを変更',
//       updateYourPassword: 'パスワードを更新',
//       emailSettings: 'メール設定',
//       manageEmailPreferences: 'メール設定を管理',
//       login: 'ログイン',
//       signInToYourAccount: 'アカウントにサインイン',
//       register: '登録',
//       createNewAccount: '新しいアカウントを作成',
//       preferences: '環境設定',
//       notifications: '通知',
//       pushNotifications: 'プッシュ通知',
//       theme: 'テーマ',
//       darkMode: 'ダークモード',
//       support: 'サポート',
//       helpSupport: 'ヘルプとサポート',
//       getHelpWithMenuScan: 'MenuScan のヘルプ',
//       sendFeedback: 'フィードバックを送信',
//       helpUsImprove: '改善にご協力ください',
//       version: 'バージョン 1.0.0',
//       accountManagement: 'アカウント管理',
//       logout: 'ログアウト',
//       signOutOfYourAccount: 'アカウントからサインアウト',
//       deleteAccount: 'アカウントを削除',
//       permanentlyDeleteYourAccount: 'アカウントを完全に削除',
//       active: 'アクティブ',
//       user: 'ユーザー',
//       email: 'メール',
//       loggedOutSuccessfully: 'ログアウトしました',
//       areYouSureYouWantToLogout: 'ログアウトしてもよろしいですか？',
//       cancel: 'キャンセル',
//       delete: '削除',
//       thisActionCannotBeUndone:
//           'この操作は元に戻せません。アカウントを完全に削除してもよろしいですか？',
//       fullName: '氏名',
//       phoneNumber: '電話番号',
//       save: '保存',
//       saving: '保存中...',
//       profileUpdatedSuccessfully: 'プロフィールを更新しました',
//       currentPassword: '現在のパスワード',
//       newPassword: '新しいパスワード',
//       confirmNewPassword: '新しいパスワードを確認',
//       updatePassword: 'パスワードを更新',
//       passwordChangedSuccessfully: 'パスワードを変更しました',
//       pleaseEnterYourName: '名前を入力してください',
//       pleaseEnterYourEmail: 'メールアドレスを入力してください',
//       pleaseEnterYourCurrentPassword: '現在のパスワードを入力してください',
//       pleaseEnterANewPassword: '新しいパスワードを入力してください',
//       passwordMustBeAtLeast6Characters:
//           'パスワードは6文字以上である必要があります',
//       pleaseConfirmYourNewPassword:
//           '新しいパスワードを確認してください',
//       emailNotifications: 'メール通知',
//       orderUpdates: '注文の更新',
//       dark: 'ダーク',
//       light: 'ライト',
//       systemDefault: 'システムデフォルト',
//       english: '英語',
//       spanish: 'スペイン語',
//       french: 'フランス語',
//       arabic: 'アラビア語',
//       korean: '韓国語',
//       japanese: '日本語',
//       chinese: '中国語',

//       howCanWeHelpYou: 'どのようにお手伝いできますか？',
//       findQuickAnswers:
//           '以下で簡単な回答を見つけるか、直接お問い合わせください — 通常1〜2営業日以内に返信します。',
//       frequentlyAskedQuestions: 'よくある質問',
//       faqHowDoIScanAMenu: 'メニューはどうやってスキャンしますか？',
//       faqHowDoIScanAMenuAnswer:
//           'アプリを開き、ホーム画面のスキャンボタンをタップし、カメラをビジネスのQRコードに向けます。デジタルメニューが自動で読み込まれます — ダウンロード不要。',
//       faqDoINeedAccount: 'MenuScan を使うにはアカウントが必要ですか？',
//       faqDoINeedAccountAnswer:
//           'ゲストとしてメニューを閲覧できます。アカウントはお気に入りの料理の保存、フィードバックの送信、デバイス間の同期にのみ必要です。',
//       faqWhyNoMenuLoading: 'メニューが読み込まれないのはなぜですか？',
//       faqWhyNoMenuLoadingAnswer:
//           'まずインターネット接続を確認してください。QRコードが古い、またはビジネスがメニューを更新していない場合は、スタッフに新しいコードを依頼してください。メニュー画面から問題を報告することもできます。',
//       faqSaveFavorite: '料理をお気に入りに保存するには？',
//       faqSaveFavoriteAnswer:
//           'メニューを見ながら料理の横のハートアイコンをタップします。保存した料理はプロフィール → お気に入りに表示されます。',
//       faqIsDataSafe: 'データは安全ですか？',
//       faqIsDataSafeAnswer:
//           'はい。支払いデータは保存せず、スキャンは第三者と共有されません。詳細はプライバシーポリシーをご覧ください。',
//       contactSupport: 'お問い合わせとサポート',
//       emailSupport: 'メールサポート',
//       emailSupportSubtitle: 'support@menuscan.com — 1〜2日で返信',
//       reportProblem: '問題を報告',
//       reportProblemSubtitle:
//           'バグを見つけましたか？詳細をお送りいただければ迅速に修正します。',
//       suggestFeature: '機能を提案',
//       suggestFeatureSubtitle:
//           'MenuScan をより良くするアイデアをお聞かせください。',
//       rateApp: 'アプリを評価',
//       rateAppSubtitle:
//           'MenuScan を楽しんでいますか？レビューは大きな助けになります。',
//       madeWithLove: 'MenuScan v1.0.0  •  ❤️を込めて',
//       yourFeedbackShapes:
//           'あなたのフィードバックが次に何を作るかを直接形作ります。バグ、不足している機能、小さなアイデア — すべてのメッセージを読んでいます。',
//       greatReportIncludes: '良いレポートには以下が含まれます：',
//       tipWhatYouWereDoing: '何をしていたか',
//       tipWhatYouExpected: '何を期待していたか',
//       tipWhatActuallyHappened: '実際に何が起こったか',
//       tipIdeasForImproving: 'アプリを改善するアイデア',
//       shareYourFeedback: 'フィードバックを共有...',
//       submitFeedback: 'フィードバックを送信',
//       loginToSendFeedback: 'フィードバックを送るにはログイン',
//       pleaseEnterFeedback: '送信前にフィードバックを入力してください。',
//       feedbackSentThanks: 'フィードバックを送信しました！ありがとう！',
//       failedToSendFeedback:
//           'フィードバックの送信に失敗しました。後でもう一度お試しください。',
//       foodDeliveryApp: 'フードデリバリーアプリ',

//       searchPosts: '投稿を検索...',
//       searchPostsOrPlaces: '投稿や場所を検索...',
//       byDate: '日付順',
//       byPopularity: '人気順',
//       noPostsFound: '投稿が見つかりません',
//       errorLoadingPosts: '投稿の読み込みエラー',
//       errorLoadingMore: 'さらに読み込みエラー',
//       failedToLoadPosts: '投稿の読み込みに失敗しました',
//       failedToToggleLike: 'いいねの切り替えに失敗しました',
//       failedToSharePost: '投稿の共有に失敗しました',
//       userNotAuthenticated:
//           'ユーザーが認証されていません。まずログインしてください。',
//       unknownErrorOccurred: '不明なエラーが発生しました',
//       checkOutThisPost: 'この投稿をチェック！',
//       checkOut: 'チェック：',
//       like: 'いいね',
//       likes: 'いいね',
//       comment: 'コメント',
//       comments: 'コメント',
//       share: '共有',
//       shares: '共有',
//       showMore: 'もっと見る',
//       showLess: '折りたたむ',
//       date: '日付',
//       time: '時間',
//       organizer: '主催者',
//       sideBar: 'サイドバー',
//       post: '投稿',
//       integrateQrHint: 'ここに mobile_scanner パッケージを統合してください',

//       aboutTitle: '情報',
//       digitalMenus: 'デジタルメニュー',
//       digitalMenusSubtitle: 'QRコードをスキャンしてメニューを即閲覧',
//       fastScanning: '高速スキャン',
//       fastScanningSubtitle: '素早いアクセスのための内蔵スキャナー',
//       savedEvents: '保存した投稿',
//       savedEventsSubtitle: 'お気に入りにした投稿',
//       shareMenus: 'メニューを共有',
//       shareMenusSubtitle: '友人や家族にメニューを送信',
//       rateUs: '評価する',
//       madeWithLoveBy: 'MenuScanチームが❤️を込めて制作',
//       allRightsReserved: '© 2025 MenuScan. 全著作権所有。',

//       weAreHereToHelp: 'お手伝いします',
//       contactSupportSubtitle:
//           '質問に合ったチャネルをお選びください。ほとんどのメッセージに1〜2営業日以内に返信します。',
//       reachUs: 'お問い合わせ',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: '一般的な質問とアカウントのヘルプ',
//       reportBug: 'バグを報告',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: 'クラッシュ、不具合、壊れたメニュー',
//       privacyInquiries: 'プライバシーに関するお問い合わせ',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: 'データアクセス、削除、または懸念事項',
//       legal: '法的情報',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: '規約、ライセンス、商標の問題',
//       beforeYouWrite: '書く前に',
//       includeTheseDetails: '迅速にサポートできるよう以下の詳細を含めてください：',
//       yourAccountEmail: 'アカウントのメール（該当する場合）',
//       appVersion: 'アプリのバージョン（設定 → 情報）',
//       deviceAndOs: 'デバイスとOS（例: Pixel 7、Android 14）',
//       stepsToReproduce: '問題を再現する手順',
//       screenshots: 'スクリーンショットまたは画面録画',
//       responseTimes: '応答時間',
//       generalInquiries: '一般的なお問い合わせ',
//       bugReports: 'バグレポート',
//       privacyRequests: 'プライバシーリクエスト',
//       criticalIssues: '重大な問題',
//       followUs: 'フォローする',
//       website: 'ウェブサイト',
//       twitter: 'Twitter',
//       instagram: 'Instagram',
//       sendInAppFeedback: 'アプリ内フィードバックを送信',
//       weReadEveryMessage:
//           'すべてのメッセージを読んでいます。改善にご協力いただきありがとうございます。',

//       yourPrivacyMatters: 'あなたのプライバシーは重要です',
//       privacyIntro:
//           'このポリシーは、MenuScanが収集するデータ、収集する理由、そしてあなたがコントロールを保つ方法を説明します。わかりやすい言葉で、法的なトリックはありません。',
//       lastUpdated: '最終更新: 2025年1月',
//       informationWeCollect: '収集する情報',
//       informationWeCollectBody:
//           'MenuScanの運営に必要なものだけを収集します:\n\n• アカウントデータ — 登録時のメールとユーザー名。\n• 使用データ — スキャンしたメニュー、閲覧した料理、アプリのクラッシュ（匿名化）。\n• デバイスデータ — OSバージョンとアプリバージョン、バグ修正に使用。\n• フィードバック — 自発的に送信されたものすべて。',
//       howWeUseYourData: 'データの使用方法',
//       howWeUseYourDataBody:
//           'あなたのデータは以下に使用されます:\n\n• スキャンしたQRコードからデジタルメニューを表示。\n• デバイス間でお気に入りを同期。\n• アプリのパフォーマンスを改善し、バグを修正。\n• サポートリクエストに応答。\n\n広告主や第三者にデータを販売することはありません。',
//       sharingThirdParties: '共有と第三者',
//       sharingThirdPartiesBody:
//           '厳格な契約の下で必須のサービスプロバイダー（ホスティング、分析、クラッシュレポート）とのみデータを共有します。明示的な同意なしにビジネスやマーケターと個人データを共有することはありません。',
//       dataRetention: 'データの保持',
//       dataRetentionBody:
//           'アカウントデータはアカウントが有効な間保持されます。匿名の使用データは最大12か月保持されます。フィードバックは解決後6か月間保存されます。いつでも削除をリクエストできます。',
//       yourRights: 'あなたの権利',
//       yourRightsBody:
//           'あなたには以下の権利があります:\n\n• データのコピーにアクセス。\n• 不正確な情報を訂正。\n• アカウントと関連データを削除。\n• 必須でない分析を拒否。\n\nいずれかを行使するには、privacy@menuscan.com までメールしてください。',
//       cookiesTracking: 'Cookieとトラッキング',
//       cookiesTrackingBody:
//           'モバイルアプリはCookieを使用しません。分析は設定 → プライバシーで無効にできる匿名イベントトラッキングに限定されています。',
//       childrensPrivacy: '子どものプライバシー',
//       childrensPrivacyBody:
//           'MenuScanは13歳未満の子どもを対象としていません。子どものデータを故意に収集することはありません。子どもがデータを提供したと思われる場合は、即時削除のためにご連絡ください。',
//       changesToThisPolicy: 'このポリシーの変更',
//       changesToThisPolicyBody:
//           '重要な変更が有効になる前にアプリ内で通知します。その日以降も使用を続けることは、更新されたポリシーに同意することを意味します。',
//       contactUs: 'お問い合わせ',
//       contactUsBody:
//           'プライバシーについてご質問がありますか？以下までご連絡ください:\n\nメール: privacy@menuscan.com\n応答時間: 1〜2営業日。',

//       termsOfService: '利用規約',
//       rulesOfUsing: 'MenuScan の利用ルール',
//       termsIntro:
//           'MenuScanをダウンロードまたは使用することにより、これらの規約に同意します。よくお読みください — 私たちに期待できることと、私たちが期待することを定義しています。',
//       effective: '発効: 2025年1月',
//       acceptanceOfTerms: '1. 規約の受諾',
//       acceptanceOfTermsBody:
//           'アカウントを作成するかMenuScanを使用することにより、少なくとも13歳以上であり、これらの規約に同意することを確認します。同意しない場合は、アプリを使用しないでください。',
//       yourAccount: '2. あなたのアカウント',
//       yourAccountBody:
//           'あなたは以下に責任があります:\n\n• ログイン資格情報を安全に保つこと。\n• アカウントで発生するすべての活動。\n• 不正使用を直ちに通知すること。\n\nこれらの規約に違反するアカウントは停止される場合があります。',
//       acceptableUse: '3. 許容される使用',
//       acceptableUseBody:
//           'あなたは以下を行わないことに同意します:\n\n• アプリをリバースエンジニアリング、コピー、または再販売すること。\n• 悪意のあるコードをアップロードしたり、サービスを妨害しようとすること。\n• 許可なくメニューやユーザーデータをスクレイピングすること。\n• フィードバックを通じて虚偽、虐待的、または違法なコンテンツを送信すること。\n\n違反はアカウントの永久終了につながる場合があります。',
//       menuContent: '4. メニューコンテンツ',
//       menuContentBody:
//           'メニューデータはビジネスによって提供されます。情報を正確に保つよう努めていますが、価格、アレルゲン、または可用性を保証するものではありません。特にアレルギーの場合は、注文前に必ずビジネスのスタッフに確認してください。',
//       intellectualProperty: '5. 知的財産',
//       intellectualPropertyBody:
//           'MenuScanの名前、ロゴ、アプリのコードは当社が所有しています。メニューコンテンツはそれぞれのビジネスに属します。書面による許可なく当社のブランドを使用することはできません。',
//       serviceAvailability: '6. サービスの可用性',
//       serviceAvailabilityBody:
//           '99%の稼働時間を目指していますが、中断のないサービスを保証するものではありません。メンテナンス、アップデート、または当社の制御を超えた理由により、一時的にアクセスを停止する場合があります。',
//       limitationOfLiability: '7. 責任の制限',
//       limitationOfLiabilityBody:
//           'MenuScanは「現状のまま」提供されます。法律で許容される最大限の範囲で、誤ったメニュー情報を含む、アプリの使用から生じる間接的な損害について責任を負いません。',
//       termination: '8. 終了',
//       terminationBody:
//           '設定からいつでもアカウントを削除できます。これらの規約に違反した場合、通知の有無にかかわらずアクセスを終了または停止することがあります。',
//       changesToTerms: '9. 規約の変更',
//       changesToTermsBody:
//           'これらの規約を時々更新することがあります。重要な変更はアプリ内で発表されます。変更後も使用を続けることは、新しい規約に同意することを意味します。',
//       contact: '10. お問い合わせ',
//       contactBody:
//           'これらの規約についてご質問がありますか？\n\nメール: legal@menuscan.com',

//       appearance: '外観',
//       chooseYourLook: 'スタイルを選択',
//       appearanceSubtitle:
//           'MenuScanの表示方法を選択してください。選択は自動的に保存され、すべての画面に適用されます。',
//       themeMode: 'テーマモード',
//       systemDefaultSubtitle: 'デバイスのライト/ダーク設定に従う',
//       lightSubtitle: '明るい背景、昼間に目に優しい',
//       darkSubtitle: '暗い背景、夜に目に優しい',
//       preview: 'プレビュー',
//       sampleMenuItem: 'サンプルメニュー項目',
//       sampleMenuItemDesc:
//           '季節の野菜と軽いレモンソースを添えたグリルチキン。',
//       primary: 'プライマリ',
//       secondary: 'セカンダリ',
//       systemDefaultInfo:
//           'システムデフォルトは、デバイスの時間と設定に基づいてライトとダークを自動的に切り替えます。',

//       notAuthenticated: '認証されていません',
//       passwordMin8: 'パスワードは8文字以上である必要があります',
//       newPasswordsDoNotMatch: '新しいパスワードが一致しません',

//       deleteAccountConfirm:
//           'この操作は元に戻せません。アカウントを完全に削除してもよろしいですか？',
//       deleteMyAccount: 'アカウントを削除',
//       yourAccountHasBeenDeleted: 'アカウントが削除されました。',
//       failedToDeleteAccount: 'アカウントの削除に失敗しました。',
//       notLoggedIn: 'ログインしていません。',

//       feedback: 'フィードバック',
//       shareFeedback: 'フィードバックを共有',
//       feedbackIntro:
//           'MenuScanの改善にご協力ください。バグの報告、機能の提案、またはご意見をお聞かせください。',
//       feedbackType: 'フィードバックの種類',
//       bugReport: 'バグレポート',
//       featureRequest: '機能リクエスト',
//       generalFeedback: '一般的なフィードバック',
//       feedbackMessage: 'メッセージ...',
//       submit: '送信',
//       submitting: '送信中...',
//       feedbackSubmitted: 'ありがとうございます！フィードバックが送信されました。',
//       feedbackFailed:
//           'フィードバックの送信に失敗しました。もう一度お試しください。',
//       pleaseEnterMessage: '送信前にメッセージを入力してください。',

//       loading: '読み込み中...',
//       error: 'エラー',
//       success: '成功',
//       ok: 'OK',
//       yes: 'はい',
//       no: 'いいえ',
//       back: '戻る',
//     ),

//     // ====================================================================
//     // ============================== CHINESE =============================
//     // ====================================================================
//     'zh': AppStrings(
//       settings: '设置',
//       language: '语言',
//       chooseLanguage: '选择语言',
//       scanQrCode: '扫描二维码',
//       scanToViewMenu: '扫描查看菜单并立即下单',
//       nearbyRestaurants: '附近商家',
//       popularCategories: '热门分类',
//       offers: '优惠',
//       seeAll: '查看全部',
//       searchRestaurants: '按名称搜索商家...',
//       getDirections: '获取路线',
//       menu: '产品与商品',
//       noMenuAvailable: '无菜单',
//       home: '首页',
//       discover: '发现',
//       events: '帖子',
//       profile: '我的',
//       restaurants: '商家',
//       filtered: '已筛选',
//       byDistance: '按距离',
//       byReviews: '按评价',
//       noRestaurantsFound: '未找到商家',
//       noCategoriesAvailable: '暂无可用分类',
//       searchRestaurantsOrPlaces: '搜索商家或地点...',
//       searchDishesOrRestaurants: '搜索菜品或商家...',
//       reviews: '条评价',
//       closed: '已打烊',
//       discoverFoods: '发现美食',
//       topRated: '评分最高的商家',
//       nearby: '附近商家',
//       noDishesFound: '未找到菜品',
//       close: '关闭',

//       scanQrTitle: '扫描二维码',
//       pointCameraAtQr: '将相机对准桌上的二维码',
//       loadingMenu: '正在加载菜单...',
//       invalidQr: '二维码无效。请扫描商家菜单二维码。',
//       couldNotLoadMenu: '无法加载菜单。请确保后端正在运行。',
//       couldNotOpenMaps: '无法打开谷歌地图',

//       open: '营业中',
//       noName: '无名称',
//       noLocation: '无位置',
//       noDescription: '无描述',
//       description: '描述',
//       addToCart: '加入购物车',
//       addedToCart: '已加入购物车',

//       welcomeBack: '欢迎回来！',
//       loginSubtitle:
//           '登录您的账户以继续\n下单和管理菜单。',
//       username: '用户名',
//       password: '密码',
//       rememberMe: '记住我',
//       forgotPassword: '忘记密码？',
//       logIn: '登录',
//       or: '或',
//       continueWithGoogle: '使用 Google 继续',
//       dontHaveAccount: '还没有账户？ ',
//       signUp: '注册',
//       createAccount: '创建账户',
//       signupSubtitle:
//           '注册以开始探索并\n管理您喜爱的商家。',
//       fullNameHint: '全名',
//       emailAddress: '电子邮件地址',
//       emailHint: '邮箱',
//       confirmPassword: '确认密码',
//       agreeToTerms: '我同意 ',
//       and: ' 和 ',
//       privacyPolicy: '隐私政策',
//       alreadyHaveAccount: '已有账户？ ',
//       loginSuccessfully: '登录成功',
//       loginFailed: '检查网络连接或用户名/密码是否正确',
//       pleaseEnterUsernameAndPassword: '请输入用户名和密码',
//       anErrorOccurred: '发生错误。请重试。',
//       failedToGetIdToken: '无法从 Google 获取 ID 令牌。',
//       googleLoginFailed: 'Google 登录失败。',
//       somethingWentWrong: '出现问题。请重试。',
//       googleSignUpComingSoon: 'Google 注册即将推出！',

//       pleaseEnterFullName: '请输入您的全名',
//       pleaseEnterValidEmail: '请输入有效的电子邮件地址',
//       pleaseEnterValidPhone: '请输入有效的电话号码',
//       passwordMin6: '密码必须至少为 6 个字符',
//       passwordsDoNotMatch: '密码不匹配',
//       pleaseAgreeToTerms: '请同意条款和条件',
//       accountCreatedSuccessfully: '账户创建成功！',
//       registrationFailed: '注册失败',
//       networkError: '网络错误。请检查您的连接。',
//       connectionError: '连接错误。请重试。',

//       createProfile: '创建资料',
//       createProfileSubtitle:
//           '完成您的资料以开始\n并连接优秀的商家。',
//       enterFullName: '输入您的全名',
//       enterEmail: '输入您的电子邮件地址',
//       enterPhone: '输入您的电话号码',
//       enterLocation: '输入您的位置',
//       selectBirthDate: '选择您的出生日期',
//       tellUsAboutYourself: '介绍一下您自己',
//       bio: '简介',
//       birthDate: '出生日期',
//       location: '位置',
//       skipForNow: '暂时跳过',
//       saveChanges: '保存更改',
//       profileCreatedSuccessfully: '资料创建成功！',
//       tapPhotoToChange: '点击照片进行更改',
//       nameCannotBeEmpty: '名称不能为空',
//       enterValidEmail: '输入有效的电子邮件',

//       profileId: '资料 ID',
//       activity: '活动',
//       birthday: '生日',
//       about: '关于',
//       contactInformation: '联系信息',
//       notSet: '未设置',
//       message: '消息',
//       edit: '编辑',
//       retry: '重试',
//       messageComingSoon: '消息功能即将推出',

//       account: '账户',
//       editProfile: '编辑资料',
//       updatePersonalInfo: '更新您的个人信息',
//       changePassword: '修改密码',
//       updateYourPassword: '更新您的密码',
//       emailSettings: '邮箱设置',
//       manageEmailPreferences: '管理邮箱偏好',
//       login: '登录',
//       signInToYourAccount: '登录您的账户',
//       register: '注册',
//       createNewAccount: '创建新账户',
//       preferences: '偏好设置',
//       notifications: '通知',
//       pushNotifications: '推送通知',
//       theme: '主题',
//       darkMode: '深色模式',
//       support: '支持',
//       helpSupport: '帮助与支持',
//       getHelpWithMenuScan: '获取 MenuScan 帮助',
//       sendFeedback: '发送反馈',
//       helpUsImprove: '帮助我们改进',
//       version: '版本 1.0.0',
//       accountManagement: '账户管理',
//       logout: '退出登录',
//       signOutOfYourAccount: '退出您的账户',
//       deleteAccount: '删除账户',
//       permanentlyDeleteYourAccount: '永久删除您的账户',
//       active: '活跃',
//       user: '用户',
//       email: '邮箱',
//       loggedOutSuccessfully: '已成功退出登录',
//       areYouSureYouWantToLogout: '您确定要退出登录吗？',
//       cancel: '取消',
//       delete: '删除',
//       thisActionCannotBeUndone:
//           '此操作无法撤销。您确定要永久删除您的账户吗？',
//       fullName: '全名',
//       phoneNumber: '电话号码',
//       save: '保存',
//       saving: '保存中...',
//       profileUpdatedSuccessfully: '资料更新成功',
//       currentPassword: '当前密码',
//       newPassword: '新密码',
//       confirmNewPassword: '确认新密码',
//       updatePassword: '更新密码',
//       passwordChangedSuccessfully: '密码修改成功',
//       pleaseEnterYourName: '请输入您的姓名',
//       pleaseEnterYourEmail: '请输入您的邮箱',
//       pleaseEnterYourCurrentPassword: '请输入当前密码',
//       pleaseEnterANewPassword: '请输入新密码',
//       passwordMustBeAtLeast6Characters: '密码必须至少为 6 个字符',
//       pleaseConfirmYourNewPassword: '请确认您的新密码',
//       emailNotifications: '邮件通知',
//       orderUpdates: '订单更新',
//       dark: '深色',
//       light: '浅色',
//       systemDefault: '系统默认',
//       english: '英语',
//       spanish: '西班牙语',
//       french: '法语',
//       arabic: '阿拉伯语',
//       korean: '韩语',
//       japanese: '日语',
//       chinese: '中文',

//       howCanWeHelpYou: '我们能如何帮助您？',
//       findQuickAnswers:
//           '在下方查找快速答案，或直接联系我们 — 我们通常在 1–2 个工作日内回复。',
//       frequentlyAskedQuestions: '常见问题',
//       faqHowDoIScanAMenu: '如何扫描菜单？',
//       faqHowDoIScanAMenuAnswer:
//           '打开应用，点击主屏幕上的扫描按钮，将相机对准商家的二维码。数字菜单将自动加载 — 无需下载。',
//       faqDoINeedAccount: '使用 MenuScan 需要账户吗？',
//       faqDoINeedAccountAnswer:
//           '您可以以访客身份浏览菜单。只有在保存喜欢的菜品、发送反馈或在设备间同步时才需要账户。',
//       faqWhyNoMenuLoading: '为什么菜单无法加载？',
//       faqWhyNoMenuLoadingAnswer:
//           '请先检查您的网络连接。如果二维码已过期或商家尚未更新菜单，请向工作人员索取新代码。您也可以在菜单页面报告该问题。',
//       faqSaveFavorite: '如何将菜品保存到收藏？',
//       faqSaveFavoriteAnswer:
//           '在查看菜单时点击任意菜品旁边的爱心图标。保存的菜品会显示在 个人资料 → 收藏。',
//       faqIsDataSafe: '我的数据安全吗？',
//       faqIsDataSafeAnswer:
//           '是的。我们从不存储支付数据，您的扫描不会与第三方共享。详情请查看我们的隐私政策。',
//       contactSupport: '联系与支持',
//       emailSupport: '邮件支持',
//       emailSupportSubtitle: 'support@menuscan.com — 1–2 天内回复',
//       reportProblem: '报告问题',
//       reportProblemSubtitle:
//           '发现错误？将详细信息发送给我们，我们会尽快修复。',
//       suggestFeature: '建议功能',
//       suggestFeatureSubtitle: '告诉我们如何让 MenuScan 更适合您。',
//       rateApp: '评价应用',
//       rateAppSubtitle: '喜欢 MenuScan 吗？一条评价对我们帮助很大。',
//       madeWithLove: 'MenuScan v1.0.0  •  用 ❤️ 制作',
//       yourFeedbackShapes:
//           '您的反馈直接影响我们接下来构建的内容。无论是错误、缺少的功能还是小想法 — 我们都会阅读每一条消息。',
//       greatReportIncludes: '一份好的报告包括：',
//       tipWhatYouWereDoing: '您当时在做什么',
//       tipWhatYouExpected: '您期望发生什么',
//       tipWhatActuallyHappened: '实际发生了什么',
//       tipIdeasForImproving: '改进应用的想法',
//       shareYourFeedback: '分享您的反馈...',
//       submitFeedback: '提交反馈',
//       loginToSendFeedback: '登录后发送反馈',
//       pleaseEnterFeedback: '提交前请输入您的反馈。',
//       feedbackSentThanks: '反馈已发送！谢谢！',
//       failedToSendFeedback: '发送反馈失败。请稍后重试。',
//       foodDeliveryApp: '外卖应用',

//       searchPosts: '搜索帖子...',
//       searchPostsOrPlaces: '搜索帖子或地点...',
//       byDate: '按日期',
//       byPopularity: '按热度',
//       noPostsFound: '未找到帖子',
//       errorLoadingPosts: '加载帖子出错',
//       errorLoadingMore: '加载更多出错',
//       failedToLoadPosts: '加载帖子失败',
//       failedToToggleLike: '切换点赞失败',
//       failedToSharePost: '分享帖子失败',
//       userNotAuthenticated: '用户未认证。请先登录。',
//       unknownErrorOccurred: '发生未知错误',
//       checkOutThisPost: '快来看看这个帖子！',
//       checkOut: '查看：',
//       like: '点赞',
//       likes: '点赞',
//       comment: '评论',
//       comments: '评论',
//       share: '分享',
//       shares: '分享',
//       showMore: '展开',
//       showLess: '收起',
//       date: '日期',
//       time: '时间',
//       organizer: '主办方',
//       sideBar: '侧边栏',
//       post: '帖子',
//       integrateQrHint: '在此集成 mobile_scanner 包',

//       aboutTitle: '关于',
//       digitalMenus: '数字菜单',
//       digitalMenusSubtitle: '扫描二维码即可浏览菜单',
//       fastScanning: '快速扫描',
//       fastScanningSubtitle: '内置扫描器，快速访问',
//       savedEvents: '已保存的帖子',
//       savedEventsSubtitle: '您收藏的帖子',
//       shareMenus: '分享菜单',
//       shareMenusSubtitle: '将菜单发送给朋友和家人',
//       rateUs: '评价我们',
//       madeWithLoveBy: 'MenuScan 团队用 ❤️ 制作',
//       allRightsReserved: '© 2025 MenuScan. 保留所有权利。',

//       weAreHereToHelp: '我们随时为您提供帮助',
//       contactSupportSubtitle:
//           '选择适合您问题的渠道。我们通常在 1–2 个工作日内回复大多数消息。',
//       reachUs: '联系我们',
//       emailSupportAddress: 'support@menuscan.com',
//       emailSupportDesc: '一般问题与账户帮助',
//       reportBug: '报告错误',
//       reportBugAddress: 'bugs@menuscan.com',
//       reportBugDesc: '崩溃、故障或损坏的菜单',
//       privacyInquiries: '隐私查询',
//       privacyInquiriesAddress: 'privacy@menuscan.com',
//       privacyInquiriesDesc: '数据访问、删除或疑虑',
//       legal: '法律',
//       legalAddress: 'legal@menuscan.com',
//       legalDesc: '条款、许可、商标事宜',
//       beforeYouWrite: '写信之前',
//       includeTheseDetails: '包含以下详细信息，以便我们更快提供帮助：',
//       yourAccountEmail: '您的账户邮箱（如适用）',
//       appVersion: '应用版本（设置 → 关于）',
//       deviceAndOs: '设备和操作系统（例如 Pixel 7、Android 14）',
//       stepsToReproduce: '重现问题的步骤',
//       screenshots: '截图或屏幕录制',
//       responseTimes: '响应时间',
//       generalInquiries: '一般查询',
//       bugReports: '错误报告',
//       privacyRequests: '隐私请求',
//       criticalIssues: '严重问题',
//       followUs: '关注我们',
//       website: '网站',
//       twitter: 'Twitter',
//       instagram: 'Instagram',
//       sendInAppFeedback: '发送应用内反馈',
//       weReadEveryMessage:
//           '我们会阅读每一条消息。感谢您帮助我们改进。',

//       yourPrivacyMatters: '您的隐私很重要',
//       privacyIntro:
//           '本政策说明 MenuScan 收集哪些数据、为什么收集以及您如何保持控制。语言通俗，没有法律陷阱。',
//       lastUpdated: '最后更新：2025 年 1 月',
//       informationWeCollect: '我们收集的信息',
//       informationWeCollectBody:
//           '我们只收集运营 MenuScan 所需的信息：\n\n• 账户数据 — 注册时的邮箱和用户名。\n• 使用数据 — 您扫描的菜单、查看的菜品和应用崩溃（匿名化）。\n• 设备数据 — 操作系统版本和应用版本，用于修复错误。\n• 反馈 — 您自愿发送的任何内容。',
//       howWeUseYourData: '我们如何使用您的数据',
//       howWeUseYourDataBody:
//           '您的数据用于：\n\n• 从扫描的二维码显示数字菜单。\n• 在设备之间同步您的收藏。\n• 改善应用性能并修复错误。\n• 响应您的支持请求。\n\n我们从不将您的数据出售给广告商或第三方。',
//       sharingThirdParties: '共享与第三方',
//       sharingThirdPartiesBody:
//           '我们仅与基本服务提供商（托管、分析、崩溃报告）在严格合同下共享数据。未经您的明确同意，我们不会与商家或营销人员共享个人数据。',
//       dataRetention: '数据保留',
//       dataRetentionBody:
//           '账户数据在您的账户处于活动状态时保留。匿名使用数据最多保留 12 个月。反馈在解决后保留 6 个月。您可以随时请求删除。',
//       yourRights: '您的权利',
//       yourRightsBody:
//           '您有权：\n\n• 访问您的数据副本。\n• 更正不准确的信息。\n• 删除您的账户和相关数据。\n• 退出非必要分析。\n\n要行使其中任何一项，请发送电子邮件至 privacy@menuscan.com。',
//       cookiesTracking: 'Cookie 和跟踪',
//       cookiesTrackingBody:
//           '移动应用不使用 Cookie。分析仅限于匿名事件跟踪，可在 设置 → 隐私 中禁用。',
//       childrensPrivacy: '儿童隐私',
//       childrensPrivacyBody:
//           'MenuScan 不适用于 13 岁以下的儿童。我们不会故意收集儿童的数据。如果您认为儿童提供了数据，请与我们联系以立即删除。',
//       changesToThisPolicy: '本政策的变更',
//       changesToThisPolicyBody:
//           '在任何重大变更生效之前，我们会在应用内通知您。在该日期之后继续使用即表示您接受更新后的政策。',
//       contactUs: '联系我们',
//       contactUsBody:
//           '对隐私有疑问？请通过以下方式联系我们：\n\n邮箱：privacy@menuscan.com\n响应时间：1–2 个工作日。',

//       termsOfService: '服务条款',
//       rulesOfUsing: '使用 MenuScan 的规则',
//       termsIntro:
//           '下载或使用 MenuScan 即表示您同意这些条款。请阅读它们 — 它们定义了您可以从我们这里期待什么，以及我们对您的期望。',
//       effective: '生效日期：2025 年 1 月',
//       acceptanceOfTerms: '1. 条款的接受',
//       acceptanceOfTermsBody:
//           '创建账户或使用 MenuScan 即表示您确认您至少 13 岁并同意这些条款。如果您不同意，请不要使用该应用。',
//       yourAccount: '2. 您的账户',
//       yourAccountBody:
//           '您负责：\n\n• 保持您的登录凭据安全。\n• 您账户下发生的所有活动。\n• 立即通知我们任何未经授权的使用。\n\n我们可能会暂停违反这些条款的账户。',
//       acceptableUse: '3. 可接受的使用',
//       acceptableUseBody:
//           '您同意不：\n\n• 对应用进行逆向工程、复制或转售。\n• 上传恶意代码或试图破坏服务。\n• 未经许可抓取菜单或用户数据。\n• 通过反馈提交虚假、辱骂或非法内容。\n\n违规可能导致账户永久终止。',
//       menuContent: '4. 菜单内容',
//       menuContentBody:
//           '菜单数据由商家提供。虽然我们努力保持信息准确，但我们不保证价格、过敏原或可用性。下单前请务必与商家工作人员确认，尤其是对过敏。',
//       intellectualProperty: '5. 知识产权',
//       intellectualPropertyBody:
//           'MenuScan 名称、徽标和应用代码归我们所有。菜单内容属于各自的商家。未经书面许可，您不得使用我们的品牌。',
//       serviceAvailability: '6. 服务可用性',
//       serviceAvailabilityBody:
//           '我们的目标是 99% 的正常运行时间，但不保证不间断的服务。我们可能会因维护、更新或我们无法控制的原因而暂时暂停访问。',
//       limitationOfLiability: '7. 责任限制',
//       limitationOfLiabilityBody:
//           'MenuScan 按"原样"提供。在法律允许的最大范围内，我们不对因您使用应用而产生的间接损害负责，包括不正确的菜单信息。',
//       termination: '8. 终止',
//       terminationBody:
//           '您可以随时从设置中删除您的账户。如果违反这些条款，我们可能会终止或暂停访问，无论是否通知。',
//       changesToTerms: '9. 条款的变更',
//       changesToTermsBody:
//           '我们可能会偶尔更新这些条款。重大变更将在应用内公布。变更后继续使用即表示您接受新条款。',
//       contact: '10. 联系方式',
//       contactBody: '对这些条款有疑问？\n\n邮箱：legal@menuscan.com',

//       appearance: '外观',
//       chooseYourLook: '选择您的风格',
//       appearanceSubtitle:
//           '选择 MenuScan 的显示方式。您的选择会自动保存并应用于所有屏幕。',
//       themeMode: '主题模式',
//       systemDefaultSubtitle: '跟随您设备的浅色/深色设置',
//       lightSubtitle: '明亮的背景，白天对眼睛友好',
//       darkSubtitle: '暗淡的背景，夜间对眼睛更友好',
//       preview: '预览',
//       sampleMenuItem: '示例菜单项',
//       sampleMenuItemDesc: '烤鸡配时令蔬菜和清淡柠檬酱。',
//       primary: '主要',
//       secondary: '次要',
//       systemDefaultInfo:
//           '系统默认根据您设备的时间设置自动在浅色和深色之间切换。',

//       notAuthenticated: '未认证',
//       passwordMin8: '密码必须至少为 8 个字符',
//       newPasswordsDoNotMatch: '新密码不匹配',

//       deleteAccountConfirm:
//           '此操作无法撤销。您确定要永久删除您的账户吗？',
//       deleteMyAccount: '删除我的账户',
//       yourAccountHasBeenDeleted: '您的账户已被删除。',
//       failedToDeleteAccount: '删除账户失败。',
//       notLoggedIn: '您未登录。',

//       feedback: '反馈',
//       shareFeedback: '分享您的反馈',
//       feedbackIntro:
//           '帮助我们改进 MenuScan。报告错误、建议功能，或告诉我们您的想法。',
//       feedbackType: '反馈类型',
//       bugReport: '错误报告',
//       featureRequest: '功能请求',
//       generalFeedback: '一般反馈',
//       feedbackMessage: '您的消息...',
//       submit: '提交',
//       submitting: '提交中...',
//       feedbackSubmitted: '谢谢！您的反馈已提交。',
//       feedbackFailed: '提交反馈失败。请重试。',
//       pleaseEnterMessage: '提交前请输入消息。',

//       loading: '加载中...',
//       error: '错误',
//       success: '成功',
//       ok: '确定',
//       yes: '是',
//       no: '否',
//       back: '返回',
//     ),
//   };

//   static AppStrings of(String code) => _values[code] ?? _values['en']!;
// }

// extension AppStringsX on BuildContext {
//   AppStrings get tr => AppStrings.of(Localizations.localeOf(this).languageCode);
// }