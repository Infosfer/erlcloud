%% @author Ransom Richardson <ransom@ransomr.net>
%% @doc
%%
%% HTTP client abstraction for erlcloud. Simplifies changing http clients.
%% API matches lhttpc, except Config is passed instead of options for
%% future cusomizability.
%%
%% @end

-module(erlcloud_httpc).

-export([request/6]).

request(URL, Method, Hdrs, Body, Timeout, _Config) ->
	Options = [{connect_timeout, Timeout}, {recv_timeout, infinity}],

	case hackney:request(Method, URL, Hdrs, Body, Options) of
		{ok, StatusCode, _RespHeaders, ClientRef} ->
			Temp = hackney:body(ClientRef),
			erlang:display(Temp),
			case Temp of
				{ok, ResultBody} ->
					erlang:display(binary_to_list(ResultBody)), 
					{ok, {{StatusCode, undefined}, undefined, ResultBody}};
				{error, Reason} ->
					{error, Reason}
			end;
		{error, Reason} ->
			{error, Reason}
	end.