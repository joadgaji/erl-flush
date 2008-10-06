-module(parser).
-export([parse/1, parse_and_scan/1, format_error/1]).

-file("/usr/lib/erlang/lib/parsetools-1.4.1.1/include/yeccpre.hrl", 0).
%% ``The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved via the world wide web at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% The Initial Developer of the Original Code is Ericsson Utvecklings AB.
%% Portions created by Ericsson are Copyright 1999, Ericsson Utvecklings
%% AB. All Rights Reserved.''
%% 
%%     $Id $
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The parser generator will insert appropriate declarations before this line.%

parse(Tokens) ->
    yeccpars0(Tokens, false).

parse_and_scan({F, A}) -> % Fun or {M, F}
    yeccpars0([], {F, A});
parse_and_scan({M, F, A}) ->
    yeccpars0([], {{M, F}, A}).

format_error(Message) ->
    case io_lib:deep_char_list(Message) of
	true ->
	    Message;
	_ ->
	    io_lib:write(Message)
    end.

% To be used in grammar files to throw an error message to the parser
% toplevel. Doesn't have to be exported!
-compile({nowarn_unused_function,{return_error,2}}).
return_error(Line, Message) ->
    throw({error, {Line, ?MODULE, Message}}).

yeccpars0(Tokens, MFA) ->
    try yeccpars1(Tokens, MFA, 0, [], [])
    catch 
        throw: {error, {_Line, ?MODULE, _M}} = Error -> 
                   Error % probably from return_error/1
    end.

% Don't change yeccpars1/6 too much, it is called recursively by yeccpars2/8!
yeccpars1([Token | Tokens], Tokenizer, State, States, Vstack) ->
    yeccpars2(State, element(1, Token), States, Vstack, Token, Tokens,
	      Tokenizer);
yeccpars1([], {F, A}, State, States, Vstack) ->
    case apply(F, A) of
        {ok, Tokens, _Endline} ->
	    yeccpars1(Tokens, {F, A}, State, States, Vstack);
        {eof, _Endline} ->
            yeccpars1([], false, State, States, Vstack);
        {error, Descriptor, _Endline} ->
            {error, Descriptor}
    end;
yeccpars1([], false, State, States, Vstack) ->
    yeccpars2(State, '$end', States, Vstack, {'$end', 999999}, [], false).

% For internal use only.
yeccerror(Token) ->
    {error,
     {element(2, Token), ?MODULE,
      ["syntax error before: ", yecctoken2string(Token)]}}.

yecctoken2string({atom, _, A}) -> io_lib:write(A);
yecctoken2string({integer,_,N}) -> io_lib:write(N);
yecctoken2string({float,_,F}) -> io_lib:write(F);
yecctoken2string({char,_,C}) -> io_lib:write_char(C);
yecctoken2string({var,_,V}) -> io_lib:format('~s', [V]);
yecctoken2string({string,_,S}) -> io_lib:write_string(S);
yecctoken2string({reserved_symbol, _, A}) -> io_lib:format('~w', [A]);
yecctoken2string({_Cat, _, Val}) -> io_lib:format('~w', [Val]);
yecctoken2string({'dot', _}) -> io_lib:format('~w', ['.']);
yecctoken2string({'$end', _}) ->
    [];
yecctoken2string({Other, _}) when is_atom(Other) ->
    io_lib:format('~w', [Other]);
yecctoken2string(Other) ->
    io_lib:write(Other).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



-file("parser.erl", 97).

yeccpars2(0, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 17, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(1, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('E', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(2, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('J', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(3, '++', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 24, [3 | __Ss], [__T | __Stack]);
yeccpars2(3, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('I', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(4, '/=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 49, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 50, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '=<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 51, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '==', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 52, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '>', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 53, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '>=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 54, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('B', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(5, '[', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 46, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(6, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('T', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(7, '+', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, 'and', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('K', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(8, '$end', _, __Stack, _, _, _) ->
 {ok, hd(__Stack)};
yeccpars2(8, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(9, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 17, [9 | __Ss], [__T | __Stack]);
yeccpars2(9, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(10, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [10 | __Ss], [__T | __Stack]);
yeccpars2(10, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(11, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_11_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '$end', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_$end'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '$end', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, ')', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_)'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), ')', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '++', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_++'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '++', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '/=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_/='(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '/=', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_<'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '<', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '=<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_=<'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '=<', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '==', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_=='(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '==', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '>', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_>'(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '>', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, '>=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = 'yeccpars2_12_>='(__Stack),
 yeccpars2(yeccgoto('K', hd(__Ss)), '>=', __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(12, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_12_(__Stack),
 yeccpars2(yeccgoto('G', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(13, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_13_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(14, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_14_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(15, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_15_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(16, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 21, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(17, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(18, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 17, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(19, ')', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 20, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(20, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_20_(__Stack),
 __Nss = lists:nthtail(3, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(21, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(22, ')', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 23, [22 | __Ss], [__T | __Stack]);
yeccpars2(22, '++', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 24, [22 | __Ss], [__T | __Stack]);
yeccpars2(22, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(23, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_23_(__Stack),
 __Nss = lists:nthtail(3, __Ss),
 yeccpars2(yeccgoto('I', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(24, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [24 | __Ss], [__T | __Stack]);
yeccpars2(24, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(25, '+', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [25 | __Ss], [__T | __Stack]);
yeccpars2(25, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [25 | __Ss], [__T | __Stack]);
yeccpars2(25, 'and', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [25 | __Ss], [__T | __Stack]);
yeccpars2(25, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_25_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('J', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(26, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_26_(__Stack),
 yeccpars2(yeccgoto('G', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(27, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [27 | __Ss], [__T | __Stack]);
yeccpars2(27, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(28, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(29, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(30, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_30_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(31, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(32, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(33, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(34, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(35, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(36, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_36_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(37, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_37_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(38, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_38_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(39, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_39_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(40, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_40_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(41, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [41 | __Ss], [__T | __Stack]);
yeccpars2(41, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_41_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(42, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 31, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_42_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(43, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_43_(__Stack),
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(44, ')', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 45, [44 | __Ss], [__T | __Stack]);
yeccpars2(44, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(45, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_45_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(46, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 26, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [46 | __Ss], [__T | __Stack]);
yeccpars2(46, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(47, '+', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 27, [47 | __Ss], [__T | __Stack]);
yeccpars2(47, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [47 | __Ss], [__T | __Stack]);
yeccpars2(47, ']', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 48, [47 | __Ss], [__T | __Stack]);
yeccpars2(47, 'and', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [47 | __Ss], [__T | __Stack]);
yeccpars2(47, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(48, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_48_(__Stack),
 __Nss = lists:nthtail(3, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(49, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [49 | __Ss], [__T | __Stack]);
yeccpars2(49, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(50, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [50 | __Ss], [__T | __Stack]);
yeccpars2(50, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(51, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [51 | __Ss], [__T | __Stack]);
yeccpars2(51, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(52, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [52 | __Ss], [__T | __Stack]);
yeccpars2(52, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(53, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [53 | __Ss], [__T | __Stack]);
yeccpars2(53, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(54, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, boolean, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 12, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 13, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 14, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, identificador, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, len, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [54 | __Ss], [__T | __Stack]);
yeccpars2(54, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(55, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_55_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(56, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_56_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(57, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_57_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(58, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_58_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(59, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_59_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(60, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_60_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(__Other, _, _, _, _, _, _) ->
 erlang:error({yecc_bug,"1.1",{missing_state_in_action_table, __Other}}).

yeccgoto('B', 0) ->
 8;
yeccgoto('B', 9) ->
 44;
yeccgoto('B', 18) ->
 19;
yeccgoto('E', 0) ->
 7;
yeccgoto('E', 9) ->
 7;
yeccgoto('E', 18) ->
 7;
yeccgoto('E', 21) ->
 7;
yeccgoto('E', 24) ->
 25;
yeccgoto('E', 46) ->
 47;
yeccgoto('E', 49) ->
 7;
yeccgoto('E', 50) ->
 7;
yeccgoto('E', 51) ->
 7;
yeccgoto('E', 52) ->
 7;
yeccgoto('E', 53) ->
 7;
yeccgoto('E', 54) ->
 7;
yeccgoto('F', 0) ->
 6;
yeccgoto('F', 9) ->
 6;
yeccgoto('F', 10) ->
 43;
yeccgoto('F', 18) ->
 6;
yeccgoto('F', 21) ->
 6;
yeccgoto('F', 24) ->
 6;
yeccgoto('F', 27) ->
 6;
yeccgoto('F', 28) ->
 6;
yeccgoto('F', 29) ->
 6;
yeccgoto('F', 31) ->
 40;
yeccgoto('F', 32) ->
 39;
yeccgoto('F', 33) ->
 38;
yeccgoto('F', 34) ->
 37;
yeccgoto('F', 35) ->
 36;
yeccgoto('F', 46) ->
 6;
yeccgoto('F', 49) ->
 6;
yeccgoto('F', 50) ->
 6;
yeccgoto('F', 51) ->
 6;
yeccgoto('F', 52) ->
 6;
yeccgoto('F', 53) ->
 6;
yeccgoto('F', 54) ->
 6;
yeccgoto('G', 0) ->
 5;
yeccgoto('G', 9) ->
 5;
yeccgoto('G', 10) ->
 5;
yeccgoto('G', 18) ->
 5;
yeccgoto('G', 21) ->
 5;
yeccgoto('G', 24) ->
 5;
yeccgoto('G', 27) ->
 5;
yeccgoto('G', 28) ->
 5;
yeccgoto('G', 29) ->
 5;
yeccgoto('G', 31) ->
 5;
yeccgoto('G', 32) ->
 5;
yeccgoto('G', 33) ->
 5;
yeccgoto('G', 34) ->
 5;
yeccgoto('G', 35) ->
 5;
yeccgoto('G', 46) ->
 5;
yeccgoto('G', 49) ->
 5;
yeccgoto('G', 50) ->
 5;
yeccgoto('G', 51) ->
 5;
yeccgoto('G', 52) ->
 5;
yeccgoto('G', 53) ->
 5;
yeccgoto('G', 54) ->
 5;
yeccgoto('I', 0) ->
 4;
yeccgoto('I', 9) ->
 4;
yeccgoto('I', 18) ->
 4;
yeccgoto('I', 49) ->
 60;
yeccgoto('I', 50) ->
 59;
yeccgoto('I', 51) ->
 58;
yeccgoto('I', 52) ->
 57;
yeccgoto('I', 53) ->
 56;
yeccgoto('I', 54) ->
 55;
yeccgoto('J', 0) ->
 3;
yeccgoto('J', 9) ->
 3;
yeccgoto('J', 18) ->
 3;
yeccgoto('J', 21) ->
 22;
yeccgoto('J', 49) ->
 3;
yeccgoto('J', 50) ->
 3;
yeccgoto('J', 51) ->
 3;
yeccgoto('J', 52) ->
 3;
yeccgoto('J', 53) ->
 3;
yeccgoto('J', 54) ->
 3;
yeccgoto('K', 0) ->
 2;
yeccgoto('K', 9) ->
 2;
yeccgoto('K', 18) ->
 2;
yeccgoto('K', 21) ->
 2;
yeccgoto('K', 49) ->
 2;
yeccgoto('K', 50) ->
 2;
yeccgoto('K', 51) ->
 2;
yeccgoto('K', 52) ->
 2;
yeccgoto('K', 53) ->
 2;
yeccgoto('K', 54) ->
 2;
yeccgoto('T', 0) ->
 1;
yeccgoto('T', 9) ->
 1;
yeccgoto('T', 18) ->
 1;
yeccgoto('T', 21) ->
 1;
yeccgoto('T', 24) ->
 1;
yeccgoto('T', 27) ->
 42;
yeccgoto('T', 28) ->
 41;
yeccgoto('T', 29) ->
 30;
yeccgoto('T', 46) ->
 1;
yeccgoto('T', 49) ->
 1;
yeccgoto('T', 50) ->
 1;
yeccgoto('T', 51) ->
 1;
yeccgoto('T', 52) ->
 1;
yeccgoto('T', 53) ->
 1;
yeccgoto('T', 54) ->
 1;
yeccgoto(__Symbol, __State) ->
 erlang:error({yecc_bug,"1.1",{__Symbol, __State, missing_in_goto_table}}).

-compile({inline,{yeccpars2_11_,1}}).
-file("parser.yrl", 36).
yeccpars2_11_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_$end',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_$end'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_)',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_)'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_++',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_++'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_/=',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_/='([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_<',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_<'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_=<',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_=<'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_==',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_=='([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_>',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_>'([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{'yeccpars2_12_>=',1}}).
-file("parser.yrl", 15).
'yeccpars2_12_>='([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_12_,1}}).
-file("parser.yrl", 38).
yeccpars2_12_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_13_,1}}).
-file("parser.yrl", 33).
yeccpars2_13_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_14_,1}}).
-file("parser.yrl", 34).
yeccpars2_14_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_15_,1}}).
-file("parser.yrl", 37).
yeccpars2_15_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_20_,1}}).
-file("parser.yrl", 3).
yeccpars2_20_([__4,__3,__2,__1 | __Stack]) ->
 [begin
   { 'not' , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_23_,1}}).
-file("parser.yrl", 11).
yeccpars2_23_([__4,__3,__2,__1 | __Stack]) ->
 [begin
   { len , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_25_,1}}).
-file("parser.yrl", 13).
yeccpars2_25_([__3,__2,__1 | __Stack]) ->
 [begin
   { '++' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_26_,1}}).
-file("parser.yrl", 38).
yeccpars2_26_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_30_,1}}).
-file("parser.yrl", 21).
yeccpars2_30_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'and' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_36_,1}}).
-file("parser.yrl", 27).
yeccpars2_36_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'xor' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_37_,1}}).
-file("parser.yrl", 26).
yeccpars2_37_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'or' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_38_,1}}).
-file("parser.yrl", 23).
yeccpars2_38_([__3,__2,__1 | __Stack]) ->
 [begin
   { '/' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_39_,1}}).
-file("parser.yrl", 24).
yeccpars2_39_([__3,__2,__1 | __Stack]) ->
 [begin
   { '*' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_40_,1}}).
-file("parser.yrl", 25).
yeccpars2_40_([__3,__2,__1 | __Stack]) ->
 [begin
   { '%' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_41_,1}}).
-file("parser.yrl", 20).
yeccpars2_41_([__3,__2,__1 | __Stack]) ->
 [begin
   { '-' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_42_,1}}).
-file("parser.yrl", 19).
yeccpars2_42_([__3,__2,__1 | __Stack]) ->
 [begin
   { '+' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_43_,1}}).
-file("parser.yrl", 31).
yeccpars2_43_([__2,__1 | __Stack]) ->
 [begin
   { '-' , __2 }
  end | __Stack].

-compile({inline,{yeccpars2_45_,1}}).
-file("parser.yrl", 29).
yeccpars2_45_([__3,__2,__1 | __Stack]) ->
 [begin
   __2
  end | __Stack].

-compile({inline,{yeccpars2_48_,1}}).
-file("parser.yrl", 30).
yeccpars2_48_([__4,__3,__2,__1 | __Stack]) ->
 [begin
   { '[' , __3 , __1 }
  end | __Stack].

-compile({inline,{yeccpars2_55_,1}}).
-file("parser.yrl", 8).
yeccpars2_55_([__3,__2,__1 | __Stack]) ->
 [begin
   { '>=' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_56_,1}}).
-file("parser.yrl", 4).
yeccpars2_56_([__3,__2,__1 | __Stack]) ->
 [begin
   { '>' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_57_,1}}).
-file("parser.yrl", 6).
yeccpars2_57_([__3,__2,__1 | __Stack]) ->
 [begin
   { '==' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_58_,1}}).
-file("parser.yrl", 9).
yeccpars2_58_([__3,__2,__1 | __Stack]) ->
 [begin
   { '=<' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_59_,1}}).
-file("parser.yrl", 5).
yeccpars2_59_([__3,__2,__1 | __Stack]) ->
 [begin
   { '<' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_60_,1}}).
-file("parser.yrl", 7).
yeccpars2_60_([__3,__2,__1 | __Stack]) ->
 [begin
   { '/=' , __1 , __3 }
  end | __Stack].


