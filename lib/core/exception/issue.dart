export 'issue_exception.dart';
export 'issue_extensions.dart';

enum Issue {
  // Fallback
  @Message('An unknown error occurred.')
  unknownError,

  // System - General Errors
  @Message('Invalid operation attempted.')
  invalidOperation,
  @Message('Invalid argument provided.')
  invalidArgument,
  @Message('Invalid format.')
  invalidFormat,

  // System - File and IO Errors
  @Message('File not found.')
  fileNotFound,
  @Message('File format is not supported.')
  fileFormatUnsupported,
  @Message('File size is too large.')
  fileSizeExceeded,

  // System - Resource Errors
  @Message('Resource not found.')
  resourceNotFound,
  @Message('Resource already exists.')
  resourceAlreadyExists,
  @Message('Resource is locked.')
  resourceLocked,
  @Message('Resource state conflict.')
  resourceStateConflict,

  // Network - General Errors / HTTP (API)
  @Message('[400] Invalid request. Please check your input.')
  invalidRequest,
  @Message('[401] You don\'t have permission to execute this operation.')
  permissionDenied,
  @Message('[402] Server is not available. Please try again later.')
  serviceUnavailable,
  @Message('[403] Server is forbidden. Please check your access rights.')
  forbidden,
  @Message('[404] Target endpoint is not available. Please check the URL.')
  invalidEndpoint,
  @Message('Request Failed.')
  protocolError,
  @Message('Request timeout.')
  requestTimeout,
  @Message('Please enter all required fields to send this request.')
  missingRequiredField,
  @Message('Access has been denied.')
  unauthorizedAccess,
  @Message('No internet connection. Please try again later.')
  noInternet,
  @Message('Network error occurred. Please try again later.')
  networkError, // Generic
  @Message('Too many requests. Please try again later.')
  tooManyRequests,
  @Message('Batch operation Failed.')
  invalidBatchOperation,
  @Message('There was an error while sending the request.')
  sendFailed,
  @Message('There was an error while receiving the response.')
  receiveFailed,
  @Message('Request is not allowed by the server.')
  requestProhibitedByCachePolicy,
  @Message('Request is not allowed by the server.')
  requestProhibitedByProxy,
  @Message('A custom API error object was returned.')
  errorObjectReturned,

  // Network - Validation and Format Errors
  @Message('Server error occurred. Please try again later.')
  internalServerError,
  @Message('Validation error occurred.')
  validationError,
  @Message('Response is empty.')
  emptyResponse,
  @Message('Response is malformed.')
  malformedResponse,
  @Message('Data is out of range.')
  dataOutOfRange,
  @Message('Data is duplicated.')
  duplicateData,

  // Network - Authentication and Authorization Errors
  @Message('Authentication Failed.')
  authenticationFailed,
  @Message('Invalid email address.')
  invalidEmail,
  @Message('Invalid password.')
  invalidPassword,
  @Message('Invalid email or password.')
  invalidEmailOrPassword,
  @Message('Token is Expired.')
  tokenExpired,
  @Message('Invalid token.')
  tokenInvalid,
  @Message('Session is Expired.')
  sessionExpired,

  // Conversion, Parsing and Serialization Errors
  @Message('Conversion Failed.')
  conversionFailed,
  @Message('Parsing Failed.')
  parsingFailed,
  @Message('Serialization Failed.')
  serializationFailed,

  // Game Errors
  @Message('Content is not ready.')
  contentNotReady,
  @Message('Invalid amount.')
  invalidAmount,
  @Message('Your level is not high enough.')
  notEnoughLevel,
  @Message('Invalid item.')
  invalidItem,
  @Message('Item is not found.')
  missingItem,
  @Message('Invalid content.')
  invalidContent,
  @Message('Content is not found.')
  missingContent,
  @Message('Invalid character.')
  invalidCharacter,
  @Message('Character is not found.')
  missingCharacter,
  @Message('Not enough energy.')
  insufficientEnergy,
  @Message('Not enough stamina.')
  insufficientStamina,
  @Message('You don\'t have required materials.')
  insufficientMaterials,
  @Message('You don\'t have enough tokens.')
  insufficientTokens,
  @Message('You don\'t have enough currency.')
  insufficientCurrency,
  @Message('You don\'t have season pass.')
  noSeasonPass,

  // Glitch9 Internal (Uncomment if needed)
  // @Message('You don\'t have enough Glitch9 credits.')
  // insufficientWallet,
}

class Message {
  final String text;
  const Message(this.text);
}
