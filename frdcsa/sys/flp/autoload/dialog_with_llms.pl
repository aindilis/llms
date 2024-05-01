askLLM(Question,Answer) :-
	perl5_eval('$Language::Prolog::Yaswi::swi_converter->pass_as_opaque("Capability::LargeLanguageModels")',_),
	perl5_eval('use Capability::LargeLanguageModels',_),
	perl5_method('Capability::LargeLanguageModels', new, [], [LLMs]),
	perl5_method(LLMs, 'Query', ['Prompt',Question],[HashItems]),
	member(=>('Result',Answer),HashItems).

%% %% perl5_method(CycConnection, 'Connect', ['_perl_hash','User','CycAdministrator','CycKE','GeneralCycKE'], [_Result]).
%% %% perl5_method(CycConnection, 'Connect', ['_perl_hash','User','CycAdministrator','CycKE','GeneralCycKE'], [_Result]).

askClaude(Question,Answer) :-
	perl5_eval('$Language::Prolog::Yaswi::swi_converter->pass_as_opaque("Capability::LargeLanguageModels")',_),
	perl5_eval('use Capability::LargeLanguageModels',_),
	perl5_method('Capability::LargeLanguageModels', new, [], [LLMs]),
	perl5_method(LLMs, 'Query', ['Prompt',Question,'EngineNameOverride','Claude'],[HashItems]),
	member(=>('Result',Answer),HashItems).
