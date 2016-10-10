//Paths
static NSString *const kCacheImagePath = @"/Library/Caches/Images";
static NSString *const kCachePath = @"/Library/Caches";
static NSString *const kHost = @"https://www.google.com";

//Services
static NSString *const kServiceURL = @"http://processoseletivoneon.azurewebsites.net/";
static NSString *const kService_GenerateToken = @"GenerateToken";
static NSString *const kService_SendMoney = @"SendMoney";
static NSString *const kService_GetTransfers = @"GetTransfers";

//Params
static NSString *const kPName = @"nome";
static NSString *const kPEmail = @"email";
static NSString *const kPClientID = @"ClienteId";
static NSString *const kPToken = @"token";
static NSString *const kPValue = @"valor";

//Result
static NSString *const kResultID = @"Data";
static NSString *const kResultClientID = @"ClienteId";
static NSString *const kResultValue = @"Valor";
static NSString *const kResultToken = @"Token";
static NSString *const kResultDate = @"Data";

//UserDefaults
static NSString *const kUserDefaults_Name = @"nome";
static NSString *const kUserDefaults_Email = @"email";
static NSString *const kUserDefaults_Token = @"token";

//Date Formatter
static NSString *const kDateFormatter = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
static NSString *const kDateFormatterCell = @"dd MMM yyyy - HH:mm";

//Constants
static int const kRowSize = 80;
static NSString *const kCacheSQLPath = @"/Library/neondb.sqlite";

//Localizable Strings
#define LString(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:@"Localizable"]

//Fonts
#define kFont(X) [UIFont fontWithName:@"Athelas" size:X]
#define kCString(X) [NSString stringWithCString:X encoding:NSUTF8StringEncoding]

//Colors
#define kColor [UIColor colorWithRed:0/255.0 green:239/255.0 blue:174/255.0 alpha:1]
#define kColorBlue [UIColor colorWithRed:51/255.0 green:219/255.0 blue:239/255.0 alpha:1]

typedef enum {
    kPMFeedTypeInvalid = 0,
    kPMFeedTypePrayer = 1,
    kPMFeedTypeWitness
}kPMFeedType;
