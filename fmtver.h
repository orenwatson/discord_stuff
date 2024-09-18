// Interface for format verifier objects

struct format_verifier;
struct format_verifier_funid;
struct format_verifier{
union{
int (*feed_char)(struct format_verifier*,unsigned char); // feed verifier chars
int (*check_end)(struct format_verifier*); // check EOF
const char*(*get_desc)(struct format_verifier*); // get description
int (*destroy)(struct format_verifier*); // destroy
}(*funloc)(const struct format_verifier_funid*f);
};

extern const struct format_verifier_funid feed_char;
extern const struct format_verifier_funid check_end;
extern const struct format_verifier_funid get_desc;
extern const struct format_verifier_funid destroy;

struct format_verifier *new_empty();
struct format_verifier *new_ascii();
struct format_verifier *new_iso_8859();
struct format_verifier *new_utf_8();



