export 'issue_exception.dart';
export 'issue_extensions.dart';

enum Issue {
  // Fallback
  @LogMessage('An unknown error occurred.')
  unknownError,

  // System - General Errorslist
  @LogMessage('Invalid operation attempted.')
  invalidOperation,
  @LogMessage('Invalid argument provided.')
  invalidArgument,
  @LogMessage('Invalid format.')
  invalidFormat,

  // System - File and IO Errors
  @LogMessage('File not found.')
  fileNotFound,
  @LogMessage('File format is not supported.')
  fileFormatUnsupported,
  @LogMessage('File size is too large.')
  fileSizeExceeded,

  // System - Resource Errors
  @LogMessage('Resource not found.')
  resourceNotFound,
  @LogMessage('Resource already exists.')
  resourceAlreadyExists,
  @LogMessage('Resource is locked.')
  resourceLocked,
  @LogMessage('Resource state conflict.')
  resourceStateConflict,

  // Network - General Errors / HTTP (API)
  @LogMessage('[400] Invalid request. Please check your input.')
  invalidRequest,
  @LogMessage('[401] You don\'t have permission to execute this operation.')
  permissionDenied,
  @LogMessage('[402] Server is not available. Please try again later.')
  serviceUnavailable,
  @LogMessage('[403] Server is forbidden. Please check your access rights.')
  forbidden,
  @LogMessage('[404] Target endpoint is not available. Please check the URL.')
  invalidEndpoint,
  @LogMessage('Request Failed.')
  protocolError,
  @LogMessage('Request timeout.')
  requestTimeout,
  @LogMessage('Please enter all required fields to send this request.')
  missingRequiredField,
  @LogMessage('Access has been denied.')
  unauthorizedAccess,
  @LogMessage('No internet connection. Please try again later.')
  noInternet,
  @LogMessage('Network error occurred. Please try again later.')
  networkError, // Generic
  @LogMessage('Too many requests. Please try again later.')
  tooManyRequests,
  @LogMessage('Batch operation Failed.')
  invalidBatchOperation,
  @LogMessage('There was an error while sending the request.')
  sendFailed,
  @LogMessage('There was an error while receiving the response.')
  receiveFailed,
  @LogMessage('Request is not allowed by the server.')
  requestProhibitedByCachePolicy,
  @LogMessage('Request is not allowed by the server.')
  requestProhibitedByProxy,
  @LogMessage('A custom API error object was returned.')
  errorObjectReturned,

  // Network - Validation and Format Errors
  @LogMessage('Server error occurred. Please try again later.')
  internalServerError,
  @LogMessage('Validation error occurred.')
  validationError,
  @LogMessage('Response is empty.')
  emptyResponse,
  @LogMessage('Response is malformed.')
  malformedResponse,
  @LogMessage('Data is out of range.')
  dataOutOfRange,
  @LogMessage('Data is duplicated.')
  duplicateData,

  // Network - Authentication and Authorization Errors
  @LogMessage('Authentication Failed.')
  authenticationFailed,
  @LogMessage('Invalid email address.')
  invalidEmail,
  @LogMessage('Invalid password.')
  invalidPassword,
  @LogMessage('Invalid email or password.')
  invalidEmailOrPassword,
  @LogMessage('Token is Expired.')
  tokenExpired,
  @LogMessage('Invalid token.')
  tokenInvalid,
  @LogMessage('Session is Expired.')
  sessionExpired,

  // Conversion, Parsing and Serialization Errors
  @LogMessage('Conversion Failed.')
  conversionFailed,
  @LogMessage('Parsing Failed.')
  parsingFailed,
  @LogMessage('Serialization Failed.')
  serializationFailed,

  // Game Errors
  @LogMessage('Content is not ready.')
  contentNotReady,
  @LogMessage('Invalid amount.')
  invalidAmount,
  @LogMessage('Your level is not high enough.')
  notEnoughLevel,
  @LogMessage('Invalid item.')
  invalidItem,
  @LogMessage('Item is not found.')
  missingItem,
  @LogMessage('Invalid content.')
  invalidContent,
  @LogMessage('Content is not found.')
  missingContent,
  @LogMessage('Invalid character.')
  invalidCharacter,
  @LogMessage('Character is not found.')
  missingCharacter,
  @LogMessage('Not enough energy.')
  insufficientEnergy,
  @LogMessage('Not enough stamina.')
  insufficientStamina,
  @LogMessage('You don\'t have required materials.')
  insufficientMaterials,
  @LogMessage('You don\'t have enough tokens.')
  insufficientTokens,
  @LogMessage('You don\'t have enough currency.')
  insufficientCurrency,
  @LogMessage('You don\'t have season pass.')
  noSeasonPass,

  // Glitch9 Internal (Uncomment if needed)
  // @LogMessage('You don\'t have enough Glitch9 credits.')
  // insufficientWallet,
}

class LogMessage {
  final String text;
  const LogMessage(this.text);
}
