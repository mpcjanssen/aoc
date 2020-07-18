
{$IFDEF FPC}
{$PACKRECORDS C}
{$ENDIF}



  const
    TCL_ALPHA_RELEASE = 0;    
    TCL_BETA_RELEASE = 1;    
    TCL_FINAL_RELEASE = 2;    
    TCL_MAJOR_VERSION = 8;    
    TCL_MINOR_VERSION = 6;    
    TCL_RELEASE_LEVEL = TCL_FINAL_RELEASE;    
    TCL_RELEASE_SERIAL = 6;    
    TCL_VERSION = '8.6';    
    TCL_PATCH_LEVEL = '8.6.6';    
    TCL_THREAD_STACK_DEFAULT = 0;    
    TCL_THREAD_NOFLAGS = 0000;    
    TCL_THREAD_JOINABLE = 0001;    
    TCL_MATCH_NOCASE = 1 shl 0;    
    TCL_OK = 0;    
    TCL_ERROR = 1;    
    TCL_RETURN = 2;    
    TCL_BREAK = 3;    
    TCL_CONTINUE = 4;    
    TCL_RESULT_SIZE = 200;    
    TCL_SUBST_COMMANDS = 001;    
    TCL_SUBST_VARIABLES = 002;    
    TCL_SUBST_BACKSLASHES = 004;    
    TCL_SUBST_ALL = 007;    
    TCL_DSTRING_STATIC_SIZE = 200;    
    TCL_MAX_PREC = 17;    
    TCL_DOUBLE_SPACE = TCL_MAX_PREC+10;    
    TCL_INTEGER_SPACE = 24;    
    TCL_DONT_USE_BRACES = 1;    
    TCL_DONT_QUOTE_HASH = 8;    
    TCL_EXACT = 1;    
    TCL_NO_EVAL = $010000;    
    TCL_EVAL_GLOBAL = $020000;    
    TCL_EVAL_DIRECT = $040000;    
    TCL_EVAL_INVOKE = $080000;    
    TCL_CANCEL_UNWIND = $100000;    
    TCL_EVAL_NOERR = $200000;    
    TCL_GLOBAL_ONLY = 1;    
    TCL_NAMESPACE_ONLY = 2;    
    TCL_APPEND_VALUE = 4;    
    TCL_LIST_ELEMENT = 8;    
    TCL_TRACE_READS = $10;    
    TCL_TRACE_WRITES = $20;    
    TCL_TRACE_UNSETS = $40;    
    TCL_TRACE_DESTROYED = $80;    
    TCL_INTERP_DESTROYED = $100;    
    TCL_LEAVE_ERR_MSG = $200;    
    TCL_TRACE_ARRAY = $800;    
    TCL_TRACE_OLD_STYLE = $1000;    
    TCL_TRACE_RESULT_DYNAMIC = $8000;    
    TCL_TRACE_RESULT_OBJECT = $10000;    
    TCL_ENSEMBLE_PREFIX = $02;    
    TCL_TRACE_RENAME = $2000;    
    TCL_TRACE_DELETE = $4000;    
    TCL_ALLOW_INLINE_COMPILATION = $20000;    
    TCL_LINK_INT = 1;    
    TCL_LINK_DOUBLE = 2;    
    TCL_LINK_BOOLEAN = 3;    
    TCL_LINK_STRING = 4;    
    TCL_LINK_WIDE_INT = 5;    
    TCL_LINK_CHAR = 6;    
    TCL_LINK_UCHAR = 7;    
    TCL_LINK_SHORT = 8;    
    TCL_LINK_USHORT = 9;    
    TCL_LINK_UINT = 10;    
    TCL_LINK_LONG = 11;    
    TCL_LINK_ULONG = 12;    
    TCL_LINK_FLOAT = 13;    
    TCL_LINK_WIDE_UINT = 14;    
    TCL_LINK_READ_ONLY = $80;    
    TCL_HASH_KEY_RANDOMIZE_HASH = $1;    
    TCL_HASH_KEY_SYSTEM_HASH = $2;    
    TCL_HASH_KEY_TYPE_VERSION = 1;    
    TCL_SMALL_HASH_TABLE = 4;    
    TCL_STRING_KEYS = 0;    
    TCL_ONE_WORD_KEYS = 1;    
    TCL_CUSTOM_TYPE_KEYS = -(2);    
    TCL_CUSTOM_PTR_KEYS = -(1);    
    TCL_DONT_WAIT = 1 shl 1;    
    TCL_WINDOW_EVENTS = 1 shl 2;    
    TCL_FILE_EVENTS = 1 shl 3;    
    TCL_TIMER_EVENTS = 1 shl 4;    
    TCL_IDLE_EVENTS = 1 shl 5;    
    TCL_ALL_EVENTS =  not (TCL_DONT_WAIT);    
    TCL_SERVICE_NONE = 0;    
    TCL_SERVICE_ALL = 1;    
    TCL_READABLE = 1 shl 1;    
    TCL_WRITABLE = 1 shl 2;    
    TCL_EXCEPTION = 1 shl 3;    
    TCL_STDIN = 1 shl 1;    
    TCL_STDOUT = 1 shl 2;    
    TCL_STDERR = 1 shl 3;    
    TCL_ENFORCE_MODE = 1 shl 4;    
    TCL_CLOSE_READ = 1 shl 1;    
    TCL_CLOSE_WRITE = 1 shl 2;    
    TCL_CHANNEL_THREAD_INSERT = 0;    
    TCL_CHANNEL_THREAD_REMOVE = 1;    
    TCL_MODE_BLOCKING = 0;    
    TCL_MODE_NONBLOCKING = 1;    
    TCL_GLOB_TYPE_BLOCK = 1 shl 0;    
    TCL_GLOB_TYPE_CHAR = 1 shl 1;    
    TCL_GLOB_TYPE_DIR = 1 shl 2;    
    TCL_GLOB_TYPE_PIPE = 1 shl 3;    
    TCL_GLOB_TYPE_FILE = 1 shl 4;    
    TCL_GLOB_TYPE_LINK = 1 shl 5;    
    TCL_GLOB_TYPE_SOCK = 1 shl 6;    
    TCL_GLOB_TYPE_MOUNT = 1 shl 7;    
    TCL_GLOB_PERM_RONLY = 1 shl 0;    
    TCL_GLOB_PERM_HIDDEN = 1 shl 1;    
    TCL_GLOB_PERM_R = 1 shl 2;    
    TCL_GLOB_PERM_W = 1 shl 3;    
    TCL_GLOB_PERM_X = 1 shl 4;    
    TCL_UNLOAD_DETACH_FROM_INTERPRETER = 1 shl 0;    
    TCL_UNLOAD_DETACH_FROM_PROCESS = 1 shl 1;    
    TCL_CREATE_SYMBOLIC_LINK = $01;    
    TCL_CREATE_HARD_LINK = $02;    
    TCL_TOKEN_WORD = 1;    
    TCL_TOKEN_SIMPLE_WORD = 2;    
    TCL_TOKEN_TEXT = 4;    
    TCL_TOKEN_BS = 8;    
    TCL_TOKEN_COMMAND = 16;    
    TCL_TOKEN_VARIABLE = 32;    
    TCL_TOKEN_SUB_EXPR = 64;    
    TCL_TOKEN_OPERATOR = 128;    
    TCL_TOKEN_EXPAND_WORD = 256;    
    TCL_PARSE_SUCCESS = 0;    
    TCL_PARSE_QUOTE_EXTRA = 1;    
    TCL_PARSE_BRACE_EXTRA = 2;    
    TCL_PARSE_MISSING_BRACE = 3;    
    TCL_PARSE_MISSING_BRACKET = 4;    
    TCL_PARSE_MISSING_PAREN = 5;    
    TCL_PARSE_MISSING_QUOTE = 6;    
    TCL_PARSE_MISSING_VAR_BRACE = 7;    
    TCL_PARSE_SYNTAX = 8;    
    TCL_PARSE_BAD_NUMBER = 9;    
    TCL_ENCODING_START = $01;    
    TCL_ENCODING_END = $02;    
    TCL_ENCODING_STOPONERROR = $04;    
    TCL_ENCODING_NO_TERMINATE = $08;    
    TCL_ENCODING_CHAR_LIMIT = $10;    
    TCL_CONVERT_MULTIBYTE = -(1);    
    TCL_CONVERT_SYNTAX = -(2);    
    TCL_CONVERT_UNKNOWN = -(3);    
    TCL_CONVERT_NOSPACE = -(4);    
    TCL_UTF_MAX = 3;    
    TCL_LIMIT_COMMANDS = $01;    
    TCL_LIMIT_TIME = $02;    
    TCL_ARGV_CONSTANT = 15;    
    TCL_ARGV_INT = 16;    
    TCL_ARGV_STRING = 17;    
    TCL_ARGV_REST = 18;    
    TCL_ARGV_FLOAT = 19;    
    TCL_ARGV_FUNC = 20;    
    TCL_ARGV_GENFUNC = 21;    
    TCL_ARGV_HELP = 22;    
    TCL_ARGV_END = 23;    
    TCL_ZLIB_FORMAT_RAW = 1;    
    TCL_ZLIB_FORMAT_ZLIB = 2;    
    TCL_ZLIB_FORMAT_GZIP = 4;    
    TCL_ZLIB_FORMAT_AUTO = 8;    
    TCL_ZLIB_STREAM_DEFLATE = 16;    
    TCL_ZLIB_STREAM_INFLATE = 32;    
    TCL_ZLIB_COMPRESS_NONE = 0;    
    TCL_ZLIB_COMPRESS_FAST = 1;    
    TCL_ZLIB_COMPRESS_BEST = 9;    
    TCL_ZLIB_COMPRESS_DEFAULT = -(1);    
    TCL_ZLIB_NO_FLUSH = 0;    
    TCL_ZLIB_FLUSH = 2;    
    TCL_ZLIB_FULLFLUSH = 3;    
    TCL_ZLIB_FINALIZE = 4;    
    TCL_LOAD_GLOBAL = 1;    
    TCL_LOAD_LAZY = 2;    
