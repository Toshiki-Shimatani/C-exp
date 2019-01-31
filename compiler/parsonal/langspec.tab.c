/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "langspec.y" /* yacc.c:339  */

#include <stdio.h>
#include "ast.h"
#include "langspec.tab.h"

extern int yylex();
extern int yyerror();
Node *top = NULL;
Symbols *global_stable = NULL;
Symbols *stable = NULL;
 int err_flag = 0;

#line 79 "langspec.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "langspec.tab.h".  */
#ifndef YY_YY_LANGSPEC_TAB_H_INCLUDED
# define YY_YY_LANGSPEC_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    DEFINE = 258,
    ARRAY = 259,
    IDENTIFIER = 260,
    NUMBER = 261,
    FUNC = 262,
    FUNCCALL = 263,
    WHILE = 264,
    IF = 265,
    ELSE = 266,
    BREAK = 267,
    FOR = 268,
    PAREN_L = 269,
    PAREN_R = 270,
    BRACKET_L = 271,
    BRACKET_R = 272,
    BRACE_L = 273,
    BRACE_R = 274,
    ADDITION = 275,
    SUBTRACTION = 276,
    MULTIPLICATION = 277,
    DIVISION = 278,
    MODULUS = 279,
    EQUAL = 280,
    LESS = 281,
    GRATER = 282,
    GREQ = 283,
    LSEQ = 284,
    DECREMENT = 285,
    INCREMENT = 286,
    ASSIGNMENT = 287,
    SEMIC = 288,
    COMMA = 289
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 14 "langspec.y" /* yacc.c:355  */

  Node *np;
  char *name;
  Ntype op;

#line 160 "langspec.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_LANGSPEC_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 177 "langspec.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  14
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   244

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  35
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  33
/* YYNRULES -- Number of rules.  */
#define YYNRULES  82
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  171

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   289

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,    43,    43,    44,    46,    47,    49,    55,    62,    79,
      80,    82,    98,   114,   131,   137,   139,   140,   152,   167,
     181,   197,   198,   201,   202,   203,   204,   205,   206,   221,
     236,   239,   255,   260,   264,   266,   270,   272,   273,   275,
     276,   278,   279,   280,   282,   283,   285,   298,   299,   300,
     315,   331,   346,   362,   365,   368,   371,   374,   375,   377,
     378,   380,   395,   396,   411,   426,   428,   429,   432,   433,
     435,   436,   438,   440,   442,   443,   444,   445,   446,   448,
     461,   474,   475
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "DEFINE", "ARRAY", "IDENTIFIER",
  "NUMBER", "FUNC", "FUNCCALL", "WHILE", "IF", "ELSE", "BREAK", "FOR",
  "PAREN_L", "PAREN_R", "BRACKET_L", "BRACKET_R", "BRACE_L", "BRACE_R",
  "ADDITION", "SUBTRACTION", "MULTIPLICATION", "DIVISION", "MODULUS",
  "EQUAL", "LESS", "GRATER", "GREQ", "LSEQ", "DECREMENT", "INCREMENT",
  "ASSIGNMENT", "SEMIC", "COMMA", "$accept", "program", "function_list",
  "function", "pre_func", "argument_list", "argument",
  "variable_declarations", "declaration", "identifier_list",
  "statement_list", "statement", "assignment_statement",
  "arithmetic_expression", "multiplicative_expression",
  "primary_expression", "additive_operator", "multiplicative_operator",
  "unary_operator", "variable", "array_reference", "loop_statement",
  "for_initial", "for_expression", "for_update", "selection_statement",
  "if_statement", "else_statement", "break_statement", "expression",
  "comparison_operator", "function_call", "parameter_list", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289
};
# endif

#define YYPACT_NINF -75

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-75)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
      65,    42,    57,    72,   107,   -75,   102,   124,   102,    15,
      79,   110,   132,   -75,   -75,   -75,   185,   -75,   -75,    42,
     -75,   134,   147,   153,   145,   154,   150,   -75,   151,   -75,
     159,    15,   161,   131,   -10,   111,   168,    15,   -75,   184,
     -75,   179,   -75,    58,   192,   188,   189,   171,   191,   -75,
     -75,   -75,   187,   168,   -75,   202,   176,   -75,   -75,   198,
     -75,   -75,   168,   193,   195,   136,    50,   -75,   199,    50,
      50,   -75,     4,   -75,   -75,   -75,    50,    30,   -75,   196,
     181,   200,    99,   -75,   207,   201,   -75,    50,    -9,    62,
     -75,   -75,   106,   166,   204,   205,    13,   -75,   -75,    45,
      46,   168,   -75,   -75,   -75,   -75,   -75,   -75,   206,     1,
     -75,   -75,   -75,    50,   -75,   -75,   -75,    50,   183,    -6,
     208,   -75,   -75,   -75,   -75,   -75,    50,   114,   141,   -75,
      27,   194,   -75,   209,   136,   -75,    62,   -75,   -75,    50,
     197,   135,   168,   -75,   168,   -75,    66,   216,   203,   210,
     -75,   -75,   212,   -75,   -75,   213,   214,    50,   -75,   -75,
      50,   152,   -75,   -75,   -75,   135,   135,   168,   -75,   215,
     -75
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,     0,     3,     5,     0,     0,    15,
      20,     0,     0,     8,     1,     4,     0,     2,    14,     0,
      16,     0,     0,     0,     0,     0,    10,    19,     0,    11,
       0,     0,     0,     0,     0,     0,     0,     0,     9,     0,
      17,     0,    12,     0,     0,     0,     0,     0,     0,    45,
      44,    30,     0,    22,    23,     0,     0,    24,    25,    66,
      27,    26,     0,     0,     0,     0,     0,    28,     0,     0,
       0,    72,     0,     7,    21,    29,     0,     0,    67,     0,
       0,     0,    46,    47,     0,     0,    48,     0,     0,    34,
      36,    37,     0,     0,     0,     0,     0,    58,    57,     0,
       0,     0,    71,     6,    18,    13,    49,    50,    51,     0,
      39,    40,    31,     0,    41,    42,    43,     0,     0,    82,
       0,    74,    75,    76,    78,    77,     0,     0,     0,    60,
      65,     0,    32,     0,     0,    38,    33,    35,    79,     0,
       0,    73,     0,    54,     0,    69,     0,     0,     0,     0,
      59,    70,     0,    81,    80,     0,     0,     0,    63,    64,
       0,     0,    52,    53,    68,    61,    62,     0,    56,     0,
      55
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -75,   -75,    97,   -75,   -75,   211,   -75,    -4,   -75,   217,
     -49,   -74,   165,   -56,   113,   121,   -75,   -75,   -36,   -63,
     -28,   -75,   -75,   -75,   -75,   -75,   -75,   -75,   -75,   -69,
     -75,   -75,    85
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     4,     5,     6,     7,    25,    26,     8,     9,    11,
      52,    53,    54,    93,    89,    90,   113,   117,    84,    91,
      86,    57,    99,   130,   149,    58,    59,    78,    60,    94,
     126,    61,   120
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      55,    95,    85,   102,    74,    18,    39,    67,    56,    96,
      88,   110,   111,    79,   110,   111,   135,    55,     1,     2,
     100,   110,   111,    40,   112,    56,    55,    36,   139,    65,
     131,   109,   146,    62,    56,    43,   119,    97,    44,    45,
      46,    55,    47,    48,    56,    66,   106,    10,   101,    56,
      82,    83,   133,   143,   145,    82,    83,    49,    50,    87,
      49,    50,    12,    51,    87,    55,   110,   111,     1,     2,
     141,   152,     3,    56,    65,    49,    50,    13,   129,   132,
      49,    50,    65,   119,   114,   115,   116,   168,    49,    50,
      66,    55,    55,   155,   147,   156,    49,    50,   157,    56,
      56,   165,   148,    15,   166,    17,    55,    14,    55,     3,
     158,    82,    83,    19,    56,    65,    56,    41,   169,    43,
      87,   118,    44,    45,    46,    55,    47,    48,    42,    49,
      50,    55,   142,    56,    22,    23,    49,    50,    16,    56,
      28,    82,    83,    20,    49,    50,    43,    51,    21,    44,
      45,    46,    29,    47,    48,   110,   111,    43,    30,   144,
      44,    45,    46,    31,    47,    48,    49,    50,    34,    32,
     167,    49,    50,    43,    51,    35,    44,    45,    46,    37,
      47,    48,    49,    50,    33,    51,   110,   111,    22,    23,
      63,   121,   122,   123,   124,   125,    64,    68,    49,    50,
      24,    51,    69,    70,    71,    72,    73,    75,    76,    77,
      80,    81,   107,    92,   104,   103,   138,   105,   108,   127,
     128,   159,   134,   140,   153,   161,   136,   150,   151,   162,
     154,     0,   163,   164,   170,   160,    27,    98,   137,     0,
       0,     0,     0,     0,    38
};

static const yytype_int16 yycheck[] =
{
      36,    70,    65,    77,    53,     9,    16,    43,    36,     5,
      66,    20,    21,    62,    20,    21,    15,    53,     3,     4,
      76,    20,    21,    33,    33,    53,    62,    31,    34,    16,
      99,    87,     5,    37,    62,     5,    92,    33,     8,     9,
      10,    77,    12,    13,    72,    32,    82,     5,    18,    77,
       5,     6,   101,   127,   128,     5,     6,    30,    31,    14,
      30,    31,     5,    33,    14,   101,    20,    21,     3,     4,
     126,   134,     7,   101,    16,    30,    31,     5,    33,    33,
      30,    31,    16,   139,    22,    23,    24,   161,    30,    31,
      32,   127,   128,   142,   130,   144,    30,    31,    32,   127,
     128,   157,   130,     6,   160,     8,   142,     0,   144,     7,
     146,     5,     6,    34,   142,    16,   144,     6,   167,     5,
      14,    15,     8,     9,    10,   161,    12,    13,    17,    30,
      31,   167,    18,   161,     3,     4,    30,    31,    14,   167,
       6,     5,     6,    33,    30,    31,     5,    33,    16,     8,
       9,    10,     5,    12,    13,    20,    21,     5,     5,    18,
       8,     9,    10,    18,    12,    13,    30,    31,    17,    15,
      18,    30,    31,     5,    33,    16,     8,     9,    10,    18,
      12,    13,    30,    31,    34,    33,    20,    21,     3,     4,
       6,    25,    26,    27,    28,    29,    17,     5,    30,    31,
      15,    33,    14,    14,    33,    14,    19,     5,    32,    11,
      17,    16,     5,    14,    33,    19,    33,    17,    17,    15,
      15,     5,    16,    15,   139,    15,   113,    33,    19,    17,
      33,    -1,    19,    19,    19,    32,    19,    72,   117,    -1,
      -1,    -1,    -1,    -1,    33
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     7,    36,    37,    38,    39,    42,    43,
       5,    44,     5,     5,     0,    37,    14,    37,    42,    34,
      33,    16,     3,     4,    15,    40,    41,    44,     6,     5,
       5,    18,    15,    34,    17,    16,    42,    18,    40,    16,
      33,     6,    17,     5,     8,     9,    10,    12,    13,    30,
      31,    33,    45,    46,    47,    53,    55,    56,    60,    61,
      63,    66,    42,     6,    17,    16,    32,    53,     5,    14,
      14,    33,    14,    19,    45,     5,    32,    11,    62,    45,
      17,    16,     5,     6,    53,    54,    55,    14,    48,    49,
      50,    54,    14,    48,    64,    64,     5,    33,    47,    57,
      48,    18,    46,    19,    33,    17,    53,     5,    17,    48,
      20,    21,    33,    51,    22,    23,    24,    52,    15,    48,
      67,    25,    26,    27,    28,    29,    65,    15,    15,    33,
      58,    64,    33,    45,    16,    15,    49,    50,    33,    34,
      15,    48,    18,    46,    18,    46,     5,    53,    55,    59,
      33,    19,    54,    67,    33,    45,    45,    32,    53,     5,
      32,    15,    17,    19,    19,    48,    48,    18,    46,    45,
      19
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    35,    36,    36,    37,    37,    38,    38,    39,    40,
      40,    41,    41,    41,    42,    42,    43,    43,    43,    44,
      44,    45,    45,    46,    46,    46,    46,    46,    46,    46,
      46,    47,    47,    48,    48,    49,    49,    50,    50,    51,
      51,    52,    52,    52,    53,    53,    54,    54,    54,    54,
      54,    55,    55,    56,    56,    56,    56,    57,    57,    58,
      58,    59,    59,    59,    59,    59,    60,    60,    61,    61,
      62,    62,    63,    64,    65,    65,    65,    65,    65,    66,
      66,    67,    67
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     1,     2,     1,     8,     7,     2,     3,
       1,     2,     4,     7,     2,     1,     3,     6,     9,     3,
       1,     2,     1,     1,     1,     1,     1,     1,     2,     2,
       1,     4,     4,     3,     1,     3,     1,     1,     3,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     2,
       2,     4,     7,     7,     5,     9,     7,     1,     1,     2,
       1,     3,     3,     2,     2,     0,     1,     2,     7,     5,
       4,     2,     2,     3,     1,     1,     1,     1,     1,     5,
       6,     3,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 43 "langspec.y" /* yacc.c:1646  */
    {top=make_nchild_node(AST_PROGRAM, (yyvsp[-1].np), (yyvsp[0].np));}
#line 1390 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 44 "langspec.y" /* yacc.c:1646  */
    {top=make_nchild_node(AST_PROGRAM, (yyvsp[0].np), NULL);}
#line 1396 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 46 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_FUNC_LIST, (yyvsp[-1].np), (yyvsp[0].np));}
#line 1402 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 47 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_FUNC_LIST, (yyvsp[0].np), NULL);}
#line 1408 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 49 "langspec.y" /* yacc.c:1646  */
    {
  Node *nfun;
  
  nfun = make_nchild_node(AST_FUNC, (yyvsp[-7].np), (yyvsp[-5].np), (yyvsp[-2].np), (yyvsp[-1].np));
  (yyval.np) = nfun;
}
#line 1419 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 55 "langspec.y" /* yacc.c:1646  */
    {
  Node *nfun;
  
  nfun = make_nchild_node(AST_FUNC, (yyvsp[-6].np), NULL, (yyvsp[-2].np), (yyvsp[-1].np));
  (yyval.np) = nfun;
}
#line 1430 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 62 "langspec.y" /* yacc.c:1646  */
    {
  Node *nid;
  Symbols *stmp;
  char errmsg[1024];

  if(sym_lookup(global_stable, (yyvsp[0].name)) == -1){
    stmp = sym_add(global_stable, (yyvsp[0].name), SYM_FUNC,0,0);
    stmp->branch = stable;
    nid = make_ident_node(SYM_FUNC, stmp->symno, NULL);
    (yyval.np) = nid;
  } else {
    sprintf(errmsg, "Function name is redefined : %s", (yyvsp[0].name));
    yyerror(errmsg);
    err_flag = 1;
  }
}
#line 1451 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 79 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_ARG_LIST, (yyvsp[-2].np), (yyvsp[0].np));}
#line 1457 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 80 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_ARG_LIST, (yyvsp[0].np), NULL);}
#line 1463 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 82 "langspec.y" /* yacc.c:1646  */
    {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];

  if(sym_lookup(stable, (yyvsp[0].name)) == -1){
    stmp = sym_add(stable, (yyvsp[0].name), SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    (yyval.np) = make_nchild_node(AST_ARG, nid, NULL);
    (yyval.np)->value = 0;
  } else {
    sprintf(errmsg, "undefined id %s", (yyvsp[0].name));
    yyerror(errmsg);
    err_flag = 1;
  }
}
#line 1484 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 98 "langspec.y" /* yacc.c:1646  */
    {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];

  if(sym_lookup(stable, (yyvsp[-2].name)) == -1){
    stmp = sym_add(stable, (yyvsp[-2].name), SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    (yyval.np) = make_nchild_node(AST_ARG, nid, NULL);
    (yyval.np)->value = 1;
  } else {
    sprintf(errmsg, "undefined id %s", (yyvsp[-2].name));
    yyerror(errmsg);
    err_flag = 1;
  }
 }
#line 1505 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 114 "langspec.y" /* yacc.c:1646  */
    {
  Symbols *stmp;
  Node *nid;
  char errmsg[1024];
  
  if(sym_lookup(stable, (yyvsp[-5].name)) == -1){
    stmp = sym_add(stable, (yyvsp[-5].name), SYM_ARG_VAR, 0, 0);
    nid = make_ident_node(SYM_ARG_VAR, stmp->symno, NULL);
    (yyval.np) = make_nchild_node(AST_ARG, nid, (yyvsp[-3].np));
    (yyval.np)->value = 2;
  } else {
    sprintf(errmsg, "undefined id %s", (yyvsp[-5].name));
    yyerror(errmsg);
    err_flag = 1;
  }
}
#line 1526 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 131 "langspec.y" /* yacc.c:1646  */
    {
  Node *ntmp = (yyvsp[-1].np);
  while(ntmp->child[1] != NULL) ntmp = ntmp->child[1];
  ntmp->child[1] = (yyvsp[0].np);
  (yyval.np) = (yyvsp[-1].np);
}
#line 1537 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 137 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=(yyvsp[0].np);}
#line 1543 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 139 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[-1].np);}
#line 1549 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 140 "langspec.y" /* yacc.c:1646  */
    {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, (yyvsp[-4].name), (yyvsp[-2].np), NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    (yyval.np) = ntmp;
  } else {
    sprintf(errmsg, "used id %s", (yyvsp[-4].name));
    yyerror(errmsg);
    err_flag = 1;
  }
}
#line 1566 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 152 "langspec.y" /* yacc.c:1646  */
    {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, (yyvsp[-7].name), (yyvsp[-5].np), (yyvsp[-2].np));
  char errmsg[1024];

  if(ntmp != NULL){
    (yyval.np) = ntmp;
  } else {
    sprintf(errmsg, "used id %s", (yyvsp[-7].name));
    yyerror(errmsg);
    err_flag = 1;
  }
}
#line 1583 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 167 "langspec.y" /* yacc.c:1646  */
    {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, (yyvsp[-2].name), NULL, NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    ntmp->child[1] = (yyvsp[0].np);
    (yyval.np) = ntmp;
  } else {
    sprintf(errmsg, "used id %s", (yyvsp[-2].name));
    yyerror(errmsg);
    err_flag = 1;
    //print_symbol_table(global_stable, 0);
  }
}
#line 1602 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 181 "langspec.y" /* yacc.c:1646  */
    {
  Node *ntmp = make_new_ident_node(stable, SYM_VAR, (yyvsp[0].name), NULL, NULL);
  char errmsg[1024];

  if(ntmp != NULL){
    (yyval.np) = ntmp;
  } else {
    sprintf(errmsg, "used id %s", (yyvsp[0].name));
    yyerror(errmsg);
    err_flag = 1;
    //print_symbol_table(global_stable, 0);
  }
}
#line 1620 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 197 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_STAT_LIST, (yyvsp[-1].np), (yyvsp[0].np));}
#line 1626 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 198 "langspec.y" /* yacc.c:1646  */
    {(yyval.np)=make_nchild_node(AST_STAT_LIST, (yyvsp[0].np), NULL);}
#line 1632 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 201 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1638 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 202 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1644 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 203 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1650 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 204 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1656 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 205 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1662 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 206 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-1].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-1].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-1].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, NULL);
  (yyval.np) = make_nchild_node((yyvsp[0].op), nid);
}
#line 1682 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 221 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[0].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[0].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[0].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, NULL);
  (yyval.np) = make_nchild_node((yyvsp[-1].op), nid);
}
#line 1702 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 236 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = NULL;}
#line 1708 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 239 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-3].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-3].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-3].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }

  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node(AST_ASSIGN, nid, (yyvsp[-1].np));
}
#line 1729 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 255 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node(AST_ASSIGN, (yyvsp[-3].np), (yyvsp[-1].np));
}
#line 1737 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 261 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node((yyvsp[-1].op), (yyvsp[-2].np), (yyvsp[0].np));
}
#line 1745 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 264 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1751 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 267 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node((yyvsp[-1].op), (yyvsp[-2].np), (yyvsp[0].np));
}
#line 1759 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 270 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1765 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 272 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1771 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 273 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[-1].np);}
#line 1777 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 275 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_ADD;}
#line 1783 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 276 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_SUB;}
#line 1789 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 278 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_MUL;}
#line 1795 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 279 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_DIV;}
#line 1801 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 280 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_MOD;}
#line 1807 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 282 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_INCRE;}
#line 1813 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 283 "langspec.y" /* yacc.c:1646  */
    {(yyval.op) = AST_DECRE;}
#line 1819 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 285 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[0].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[0].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[0].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  (yyval.np) = make_ident_node(SYM_VAR, symno, stable);
}
#line 1837 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 298 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1843 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 299 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = (yyvsp[0].np);}
#line 1849 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 300 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-1].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-1].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-1].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node((yyvsp[0].op), nid);
}
#line 1869 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 315 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[0].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[0].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[0].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node((yyvsp[-1].op), nid);
}
#line 1889 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 331 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-3].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-3].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-3].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node(AST_ARRAY_REF, nid, (yyvsp[-1].np), NULL);
}
#line 1909 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 346 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-6].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-6].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-6].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node(AST_ARRAY_REF, nid, (yyvsp[-4].np), (yyvsp[-1].np));
}
#line 1929 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 362 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node(AST_WHILE, (yyvsp[-4].np), (yyvsp[-1].np));
}
#line 1937 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 365 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node(AST_WHILE, (yyvsp[-2].np), (yyvsp[0].np));
}
#line 1945 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 368 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node(AST_FOR, (yyvsp[-6].np), (yyvsp[-5].np), (yyvsp[-4].np), (yyvsp[-1].np));
}
#line 1953 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 371 "langspec.y" /* yacc.c:1646  */
    {
  (yyval.np) = make_nchild_node(AST_FOR, (yyvsp[-4].np), (yyvsp[-3].np), (yyvsp[-2].np), (yyvsp[0].np));}
#line 1960 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 374 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = (yyvsp[0].np);}
#line 1966 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 375 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = NULL;}
#line 1972 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 377 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = (yyvsp[-1].np);}
#line 1978 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 378 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = NULL;}
#line 1984 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 380 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-2].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-2].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-2].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node(AST_ASSIGN, nid, (yyvsp[0].np));
}
#line 2004 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 395 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_ASSIGN, (yyvsp[-2].np), (yyvsp[0].np));}
#line 2010 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 396 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[-1].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[-1].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[-1].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node((yyvsp[0].op), nid);
}
#line 2030 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 411 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(stable, (yyvsp[0].name))) == -1){
    if((symno = sym_lookup(global_stable, (yyvsp[0].name))) == -1){
      sprintf(errmsg, "undefined id %s", (yyvsp[0].name));
      yyerror(errmsg);
      err_flag = 1;
    }
  }
  nid = make_ident_node(SYM_VAR, symno, stable);
  (yyval.np) = make_nchild_node((yyvsp[-1].op), nid);
}
#line 2050 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 426 "langspec.y" /* yacc.c:1646  */
    {(yyval.np) = NULL;}
#line 2056 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 428 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = (yyvsp[0].np); }
#line 2062 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 429 "langspec.y" /* yacc.c:1646  */
    { (yyvsp[-1].np)->child[2] = (yyvsp[0].np); (yyval.np) = (yyvsp[-1].np); }
#line 2068 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 432 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_IF, (yyvsp[-4].np), (yyvsp[-1].np), NULL); }
#line 2074 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 69:
#line 433 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_IF, (yyvsp[-2].np), (yyvsp[0].np), NULL); }
#line 2080 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 70:
#line 435 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = (yyvsp[-1].np); }
#line 2086 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 71:
#line 436 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = (yyvsp[0].np); }
#line 2092 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 72:
#line 438 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_BREAK); }
#line 2098 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 73:
#line 440 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node((yyvsp[-1].op), (yyvsp[-2].np), (yyvsp[0].np)); }
#line 2104 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 74:
#line 442 "langspec.y" /* yacc.c:1646  */
    { (yyval.op) = AST_EQ; }
#line 2110 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 75:
#line 443 "langspec.y" /* yacc.c:1646  */
    { (yyval.op) = AST_LESS; }
#line 2116 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 76:
#line 444 "langspec.y" /* yacc.c:1646  */
    { (yyval.op) = AST_GR; }
#line 2122 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 77:
#line 445 "langspec.y" /* yacc.c:1646  */
    { (yyval.op) = AST_LSEQ; }
#line 2128 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 78:
#line 446 "langspec.y" /* yacc.c:1646  */
    { (yyval.op) = AST_GREQ; }
#line 2134 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 79:
#line 448 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(global_stable, (yyvsp[-3].name))) == -1){
    sprintf(errmsg, "undefined id %s", (yyvsp[-3].name));
    yyerror(errmsg);
    err_flag = 1;
  }
  nid = make_ident_node(SYM_FUNC, symno, NULL);
  (yyval.np) = make_nchild_node(AST_FUNCCALL, nid, NULL);
}
#line 2152 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 80:
#line 461 "langspec.y" /* yacc.c:1646  */
    {
  int symno;
  Node *nid;
  char errmsg[1024];

  if((symno = sym_lookup(global_stable, (yyvsp[-4].name))) == -1){
    sprintf(errmsg, "undefined id %s", (yyvsp[-4].name));
    yyerror(errmsg);
    err_flag = 1;
  }
  nid = make_ident_node(SYM_FUNC, symno, NULL);
  (yyval.np) = make_nchild_node(AST_FUNCCALL, nid, (yyvsp[-2].np));}
#line 2169 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 81:
#line 474 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_PARAM_LIST, (yyvsp[-2].np), (yyvsp[0].np)); }
#line 2175 "langspec.tab.c" /* yacc.c:1646  */
    break;

  case 82:
#line 475 "langspec.y" /* yacc.c:1646  */
    { (yyval.np) = make_nchild_node(AST_PARAM_LIST, (yyvsp[0].np), NULL); }
#line 2181 "langspec.tab.c" /* yacc.c:1646  */
    break;


#line 2185 "langspec.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 477 "langspec.y" /* yacc.c:1906  */

int main(){
  global_stable = sym_add(global_stable, "global", SYM_KEYWORD, 0, 0);
  stable = global_stable;
  if(yyparse()){
    fprintf(stderr, "Error\n");
    return 1;
  }
  if(err_flag != 0) {
    printf("\x1b[31m");     /* 前景色を赤に */
    printf("ERROR: ");
    printf("\x1b[39m");     /* 前景色をデフォルトに戻す */
    printf("Stopped compiling\n");
    return 1;
  }    
  printf("tree\n");
  print_ast_tree(top, global_stable, global_stable, 0);
  printf("symbol table\n");
   print_symbol_table(global_stable, 0);
  printf("code\n");
  generate_program_code(top, global_stable);
  return 0;
}

