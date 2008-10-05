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
 yeccpars1(__Ts, __Tzr, 6, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [0 | __Ss], [__T | __Stack]);
yeccpars2(0, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(1, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [1 | __Ss], [__T | __Stack]);
yeccpars2(1, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('E', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(2, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('B', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(3, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('T', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(4, '+', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 28, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 29, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, 'and', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 30, [4 | __Ss], [__T | __Stack]);
yeccpars2(4, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars2(yeccgoto('I', hd(__Ss)), __Cat, __Ss, __Stack, __T, __Ts, __Tzr);
yeccpars2(5, '$end', _, __Stack, _, _, _) ->
 {ok, hd(__Stack)};
yeccpars2(5, '/=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, '<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 17, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, '=<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, '==', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 19, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, '>', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 20, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, '>=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 21, [5 | __Ss], [__T | __Stack]);
yeccpars2(5, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(6, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [6 | __Ss], [__T | __Stack]);
yeccpars2(6, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(7, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [7 | __Ss], [__T | __Stack]);
yeccpars2(7, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(8, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_8_(__Stack),
 yeccpars2(yeccgoto('I', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(9, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_9_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(10, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_10_(__Stack),
 yeccpars2(yeccgoto('F', hd(__Ss)), __Cat, __Ss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(11, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [11 | __Ss], [__T | __Stack]);
yeccpars2(11, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [11 | __Ss], [__T | __Stack]);
yeccpars2(11, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [11 | __Ss], [__T | __Stack]);
yeccpars2(11, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [11 | __Ss], [__T | __Stack]);
yeccpars2(11, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [11 | __Ss], [__T | __Stack]);
yeccpars2(11, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(12, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_12_(__Stack),
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(13, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_13_(__Stack),
 __Nss = lists:nthtail(1, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(14, ')', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 15, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '/=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 16, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 17, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '=<', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 18, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '==', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 19, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '>', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 20, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, '>=', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 21, [14 | __Ss], [__T | __Stack]);
yeccpars2(14, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(15, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_15_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('F', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(16, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [16 | __Ss], [__T | __Stack]);
yeccpars2(16, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(17, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [17 | __Ss], [__T | __Stack]);
yeccpars2(17, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(18, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [18 | __Ss], [__T | __Stack]);
yeccpars2(18, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(19, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [19 | __Ss], [__T | __Stack]);
yeccpars2(19, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(20, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [20 | __Ss], [__T | __Stack]);
yeccpars2(20, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(21, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, cadena, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 8, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [21 | __Ss], [__T | __Stack]);
yeccpars2(21, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(22, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_22_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(23, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_23_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(24, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_24_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(25, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_25_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(26, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_26_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(27, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_27_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('B', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(28, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [28 | __Ss], [__T | __Stack]);
yeccpars2(28, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(29, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [29 | __Ss], [__T | __Stack]);
yeccpars2(29, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(30, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [30 | __Ss], [__T | __Stack]);
yeccpars2(30, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(31, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [31 | __Ss], [__T | __Stack]);
yeccpars2(31, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_31_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(32, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [32 | __Ss], [__T | __Stack]);
yeccpars2(32, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(33, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [33 | __Ss], [__T | __Stack]);
yeccpars2(33, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(34, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [34 | __Ss], [__T | __Stack]);
yeccpars2(34, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(35, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [35 | __Ss], [__T | __Stack]);
yeccpars2(35, _, _, _, __T, _, _) ->
 yeccerror(__T);
yeccpars2(36, '(', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 6, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, '-', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 7, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, entero, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 9, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, float, __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 10, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, 'not', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 11, [36 | __Ss], [__T | __Stack]);
yeccpars2(36, _, _, _, __T, _, _) ->
 yeccerror(__T);
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
yeccpars2(41, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_41_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('T', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(42, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [42 | __Ss], [__T | __Stack]);
yeccpars2(42, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_42_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(43, '%', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 32, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, '*', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 33, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, '/', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 34, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, 'or', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 35, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, 'xor', __Ss, __Stack, __T, __Ts, __Tzr) ->
 yeccpars1(__Ts, __Tzr, 36, [43 | __Ss], [__T | __Stack]);
yeccpars2(43, __Cat, __Ss, __Stack, __T, __Ts, __Tzr) ->
 __NewStack = yeccpars2_43_(__Stack),
 __Nss = lists:nthtail(2, __Ss),
 yeccpars2(yeccgoto('E', hd(__Nss)), __Cat, __Nss, __NewStack, __T, __Ts, __Tzr);
yeccpars2(__Other, _, _, _, _, _, _) ->
 erlang:error({yecc_bug,"1.1",{missing_state_in_action_table, __Other}}).

yeccgoto('B', 0) ->
 5;
yeccgoto('B', 6) ->
 14;
yeccgoto('E', 0) ->
 4;
yeccgoto('E', 6) ->
 4;
yeccgoto('E', 16) ->
 4;
yeccgoto('E', 17) ->
 4;
yeccgoto('E', 18) ->
 4;
yeccgoto('E', 19) ->
 4;
yeccgoto('E', 20) ->
 4;
yeccgoto('E', 21) ->
 4;
yeccgoto('F', 0) ->
 3;
yeccgoto('F', 6) ->
 3;
yeccgoto('F', 7) ->
 13;
yeccgoto('F', 11) ->
 12;
yeccgoto('F', 16) ->
 3;
yeccgoto('F', 17) ->
 3;
yeccgoto('F', 18) ->
 3;
yeccgoto('F', 19) ->
 3;
yeccgoto('F', 20) ->
 3;
yeccgoto('F', 21) ->
 3;
yeccgoto('F', 28) ->
 3;
yeccgoto('F', 29) ->
 3;
yeccgoto('F', 30) ->
 3;
yeccgoto('F', 32) ->
 41;
yeccgoto('F', 33) ->
 40;
yeccgoto('F', 34) ->
 39;
yeccgoto('F', 35) ->
 38;
yeccgoto('F', 36) ->
 37;
yeccgoto('I', 0) ->
 2;
yeccgoto('I', 6) ->
 2;
yeccgoto('I', 16) ->
 27;
yeccgoto('I', 17) ->
 26;
yeccgoto('I', 18) ->
 25;
yeccgoto('I', 19) ->
 24;
yeccgoto('I', 20) ->
 23;
yeccgoto('I', 21) ->
 22;
yeccgoto('T', 0) ->
 1;
yeccgoto('T', 6) ->
 1;
yeccgoto('T', 16) ->
 1;
yeccgoto('T', 17) ->
 1;
yeccgoto('T', 18) ->
 1;
yeccgoto('T', 19) ->
 1;
yeccgoto('T', 20) ->
 1;
yeccgoto('T', 21) ->
 1;
yeccgoto('T', 28) ->
 43;
yeccgoto('T', 29) ->
 42;
yeccgoto('T', 30) ->
 31;
yeccgoto(__Symbol, __State) ->
 erlang:error({yecc_bug,"1.1",{__Symbol, __State, missing_in_goto_table}}).

-compile({inline,{yeccpars2_8_,1}}).
-file("parser.yrl", 12).
yeccpars2_8_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_9_,1}}).
-file("parser.yrl", 27).
yeccpars2_9_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_10_,1}}).
-file("parser.yrl", 28).
yeccpars2_10_([__1 | __Stack]) ->
 [begin
   element ( 4 , __1 )
  end | __Stack].

-compile({inline,{yeccpars2_12_,1}}).
-file("parser.yrl", 26).
yeccpars2_12_([__2,__1 | __Stack]) ->
 [begin
   { 'not' , __2 }
  end | __Stack].

-compile({inline,{yeccpars2_13_,1}}).
-file("parser.yrl", 25).
yeccpars2_13_([__2,__1 | __Stack]) ->
 [begin
   { '-' , __2 }
  end | __Stack].

-compile({inline,{yeccpars2_15_,1}}).
-file("parser.yrl", 24).
yeccpars2_15_([__3,__2,__1 | __Stack]) ->
 [begin
   __2
  end | __Stack].

-compile({inline,{yeccpars2_22_,1}}).
-file("parser.yrl", 8).
yeccpars2_22_([__3,__2,__1 | __Stack]) ->
 [begin
   { '>=' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_23_,1}}).
-file("parser.yrl", 4).
yeccpars2_23_([__3,__2,__1 | __Stack]) ->
 [begin
   { '>' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_24_,1}}).
-file("parser.yrl", 6).
yeccpars2_24_([__3,__2,__1 | __Stack]) ->
 [begin
   { '==' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_25_,1}}).
-file("parser.yrl", 9).
yeccpars2_25_([__3,__2,__1 | __Stack]) ->
 [begin
   { '=<' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_26_,1}}).
-file("parser.yrl", 5).
yeccpars2_26_([__3,__2,__1 | __Stack]) ->
 [begin
   { '<' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_27_,1}}).
-file("parser.yrl", 7).
yeccpars2_27_([__3,__2,__1 | __Stack]) ->
 [begin
   { '/=' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_31_,1}}).
-file("parser.yrl", 16).
yeccpars2_31_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'and' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_37_,1}}).
-file("parser.yrl", 22).
yeccpars2_37_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'xor' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_38_,1}}).
-file("parser.yrl", 21).
yeccpars2_38_([__3,__2,__1 | __Stack]) ->
 [begin
   { 'or' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_39_,1}}).
-file("parser.yrl", 18).
yeccpars2_39_([__3,__2,__1 | __Stack]) ->
 [begin
   { '/' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_40_,1}}).
-file("parser.yrl", 19).
yeccpars2_40_([__3,__2,__1 | __Stack]) ->
 [begin
   { '*' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_41_,1}}).
-file("parser.yrl", 20).
yeccpars2_41_([__3,__2,__1 | __Stack]) ->
 [begin
   { '%' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_42_,1}}).
-file("parser.yrl", 15).
yeccpars2_42_([__3,__2,__1 | __Stack]) ->
 [begin
   { '-' , __1 , __3 }
  end | __Stack].

-compile({inline,{yeccpars2_43_,1}}).
-file("parser.yrl", 14).
yeccpars2_43_([__3,__2,__1 | __Stack]) ->
 [begin
   { '+' , __1 , __3 }
  end | __Stack].


