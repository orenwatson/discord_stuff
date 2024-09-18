#include "fmtver.h"
#include <stdio.h>
#include <stdlib.h>

#define OBJCALL(o,f,...) (o->funloc(&f).f(o __VA_OPT__(,) __VA_ARGS__))

struct format_verifier*(*const verifier_factories[])() = {new_empty,new_utf_8};

int main(int argc,char**argv){
	unsigned f_i,v_i;
	unsigned v_n = sizeof(verifier_factories)/sizeof(void*);
	if(argc<1)return 0;
	for(f_i=0;f_i<argc;f_i++){
		FILE *f = fopen(argv[f_i],"r");
		if(!f){perror(argv[f_i]);continue;}
		struct format_verifier**verifiers=
			(struct format_verifiers**)malloc(sizeof(void*)*v_n);
		for(v_i=0;v_i<v_n;v_i++){
			verifiers[v_i] = verifier_factories[v_i]();
		}
		int c;
		while((c=fgetc(f))!=EOF){
			for(v_i=0;v_i<v_n;v_i++){
				OBJCALL(verifiers[v_i],feed_char,c);
			}
		}
		int ident = 0;
		for(v_i=0;v_i<v_n;v_i++){
			int error=OBJCALL(verifiers[v_i],check_end);
			if(!error&&!ident){
				printf("%s:%s\n",argv[f_i],OBJCALL(verifiers[v_i],get_desc));
				ident = 1;
			}
			OBJCALL(verifiers[v_i],destroy);
		}
		if (!ident){
				printf("%s:data\n",argv[f_i]);

		}
		fclose(f);
	}

}

