#define TCL_ALPHA_RELEASE	0
#define TCL_BETA_RELEASE	1
#define TCL_FINAL_RELEASE	2
#define TCL_MAJOR_VERSION   8
#define TCL_MINOR_VERSION   6
#define TCL_RELEASE_LEVEL   TCL_FINAL_RELEASE
#define TCL_RELEASE_SERIAL  6
#define TCL_VERSION	    "8.6"
#define TCL_PATCH_LEVEL	    "8.6.6"
#define TCL_THREAD_STACK_DEFAULT (0)    
#define TCL_THREAD_NOFLAGS	 (0000) 
#define TCL_THREAD_JOINABLE	 (0001) 
#define TCL_MATCH_NOCASE	(1<<0)
#define TCL_OK			0
#define TCL_ERROR		1
#define TCL_RETURN		2
#define TCL_BREAK		3
#define TCL_CONTINUE		4
#define TCL_RESULT_SIZE		200
#define TCL_SUBST_COMMANDS	001
#define TCL_SUBST_VARIABLES	002
#define TCL_SUBST_BACKSLASHES	004
#define TCL_SUBST_ALL		007
#define TCL_DSTRING_STATIC_SIZE 200
#define TCL_MAX_PREC		17
#define TCL_DOUBLE_SPACE	(TCL_MAX_PREC+10)
#define TCL_INTEGER_SPACE	24
#define TCL_DONT_USE_BRACES	1
#define TCL_DONT_QUOTE_HASH	8
#define TCL_EXACT	1
#define TCL_NO_EVAL		0x010000
#define TCL_EVAL_GLOBAL		0x020000
#define TCL_EVAL_DIRECT		0x040000
#define TCL_EVAL_INVOKE		0x080000
#define TCL_CANCEL_UNWIND	0x100000
#define TCL_EVAL_NOERR          0x200000
#define TCL_GLOBAL_ONLY		 1
#define TCL_NAMESPACE_ONLY	 2
#define TCL_APPEND_VALUE	 4
#define TCL_LIST_ELEMENT	 8
#define TCL_TRACE_READS		 0x10
#define TCL_TRACE_WRITES	 0x20
#define TCL_TRACE_UNSETS	 0x40
#define TCL_TRACE_DESTROYED	 0x80
#define TCL_INTERP_DESTROYED	 0x100
#define TCL_LEAVE_ERR_MSG	 0x200
#define TCL_TRACE_ARRAY		 0x800
#define TCL_TRACE_OLD_STYLE	 0x1000
#define TCL_TRACE_RESULT_DYNAMIC 0x8000
#define TCL_TRACE_RESULT_OBJECT  0x10000
#define TCL_ENSEMBLE_PREFIX 0x02
#define TCL_TRACE_RENAME	0x2000
#define TCL_TRACE_DELETE	0x4000
#define TCL_ALLOW_INLINE_COMPILATION 0x20000
#define TCL_LINK_INT		1
#define TCL_LINK_DOUBLE		2
#define TCL_LINK_BOOLEAN	3
#define TCL_LINK_STRING		4
#define TCL_LINK_WIDE_INT	5
#define TCL_LINK_CHAR		6
#define TCL_LINK_UCHAR		7
#define TCL_LINK_SHORT		8
#define TCL_LINK_USHORT		9
#define TCL_LINK_UINT		10
#define TCL_LINK_LONG		11
#define TCL_LINK_ULONG		12
#define TCL_LINK_FLOAT		13
#define TCL_LINK_WIDE_UINT	14
#define TCL_LINK_READ_ONLY	0x80
#define TCL_HASH_KEY_RANDOMIZE_HASH 0x1
#define TCL_HASH_KEY_SYSTEM_HASH    0x2
#define TCL_HASH_KEY_TYPE_VERSION 1
#define TCL_SMALL_HASH_TABLE 4
#define TCL_STRING_KEYS		(0)
#define TCL_ONE_WORD_KEYS	(1)
#define TCL_CUSTOM_TYPE_KEYS	(-2)
#define TCL_CUSTOM_PTR_KEYS	(-1)
#define TCL_DONT_WAIT		(1<<1)
#define TCL_WINDOW_EVENTS	(1<<2)
#define TCL_FILE_EVENTS		(1<<3)
#define TCL_TIMER_EVENTS	(1<<4)
#define TCL_IDLE_EVENTS		(1<<5)	
#define TCL_ALL_EVENTS		(~TCL_DONT_WAIT)
#define TCL_SERVICE_NONE 0
#define TCL_SERVICE_ALL 1
#define TCL_READABLE		(1<<1)
#define TCL_WRITABLE		(1<<2)
#define TCL_EXCEPTION		(1<<3)
#define TCL_STDIN		(1<<1)
#define TCL_STDOUT		(1<<2)
#define TCL_STDERR		(1<<3)
#define TCL_ENFORCE_MODE	(1<<4)
#define TCL_CLOSE_READ		(1<<1)
#define TCL_CLOSE_WRITE		(1<<2)
#define TCL_CHANNEL_THREAD_INSERT (0)
#define TCL_CHANNEL_THREAD_REMOVE (1)
#define TCL_MODE_BLOCKING	0	
#define TCL_MODE_NONBLOCKING	1	
#define TCL_GLOB_TYPE_BLOCK		(1<<0)
#define TCL_GLOB_TYPE_CHAR		(1<<1)
#define TCL_GLOB_TYPE_DIR		(1<<2)
#define TCL_GLOB_TYPE_PIPE		(1<<3)
#define TCL_GLOB_TYPE_FILE		(1<<4)
#define TCL_GLOB_TYPE_LINK		(1<<5)
#define TCL_GLOB_TYPE_SOCK		(1<<6)
#define TCL_GLOB_TYPE_MOUNT		(1<<7)
#define TCL_GLOB_PERM_RONLY		(1<<0)
#define TCL_GLOB_PERM_HIDDEN		(1<<1)
#define TCL_GLOB_PERM_R			(1<<2)
#define TCL_GLOB_PERM_W			(1<<3)
#define TCL_GLOB_PERM_X			(1<<4)
#define TCL_UNLOAD_DETACH_FROM_INTERPRETER	(1<<0)
#define TCL_UNLOAD_DETACH_FROM_PROCESS		(1<<1)
#define TCL_CREATE_SYMBOLIC_LINK	0x01
#define TCL_CREATE_HARD_LINK		0x02
#define TCL_TOKEN_WORD		1
#define TCL_TOKEN_SIMPLE_WORD	2
#define TCL_TOKEN_TEXT		4
#define TCL_TOKEN_BS		8
#define TCL_TOKEN_COMMAND	16
#define TCL_TOKEN_VARIABLE	32
#define TCL_TOKEN_SUB_EXPR	64
#define TCL_TOKEN_OPERATOR	128
#define TCL_TOKEN_EXPAND_WORD	256
#define TCL_PARSE_SUCCESS		0
#define TCL_PARSE_QUOTE_EXTRA		1
#define TCL_PARSE_BRACE_EXTRA		2
#define TCL_PARSE_MISSING_BRACE		3
#define TCL_PARSE_MISSING_BRACKET	4
#define TCL_PARSE_MISSING_PAREN		5
#define TCL_PARSE_MISSING_QUOTE		6
#define TCL_PARSE_MISSING_VAR_BRACE	7
#define TCL_PARSE_SYNTAX		8
#define TCL_PARSE_BAD_NUMBER		9
#define TCL_ENCODING_START		0x01
#define TCL_ENCODING_END		0x02
#define TCL_ENCODING_STOPONERROR	0x04
#define TCL_ENCODING_NO_TERMINATE	0x08
#define TCL_ENCODING_CHAR_LIMIT		0x10
#define TCL_CONVERT_MULTIBYTE	(-1)
#define TCL_CONVERT_SYNTAX	(-2)
#define TCL_CONVERT_UNKNOWN	(-3)
#define TCL_CONVERT_NOSPACE	(-4)
#define TCL_UTF_MAX		3
#define TCL_LIMIT_COMMANDS	0x01
#define TCL_LIMIT_TIME		0x02
#define TCL_ARGV_CONSTANT	15
#define TCL_ARGV_INT		16
#define TCL_ARGV_STRING		17
#define TCL_ARGV_REST		18
#define TCL_ARGV_FLOAT		19
#define TCL_ARGV_FUNC		20
#define TCL_ARGV_GENFUNC	21
#define TCL_ARGV_HELP		22
#define TCL_ARGV_END		23
#define TCL_ZLIB_FORMAT_RAW	1
#define TCL_ZLIB_FORMAT_ZLIB	2
#define TCL_ZLIB_FORMAT_GZIP	4
#define TCL_ZLIB_FORMAT_AUTO	8
#define TCL_ZLIB_STREAM_DEFLATE	16
#define TCL_ZLIB_STREAM_INFLATE	32
#define TCL_ZLIB_COMPRESS_NONE	0
#define TCL_ZLIB_COMPRESS_FAST	1
#define TCL_ZLIB_COMPRESS_BEST	9
#define TCL_ZLIB_COMPRESS_DEFAULT (-1)
#define TCL_ZLIB_NO_FLUSH	0
#define TCL_ZLIB_FLUSH		2
#define TCL_ZLIB_FULLFLUSH	3
#define TCL_ZLIB_FINALIZE	4
#define TCL_LOAD_GLOBAL 1
#define TCL_LOAD_LAZY 2