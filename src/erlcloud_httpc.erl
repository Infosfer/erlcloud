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

-include("erlcloud_aws.hrl").

request(URL, Method, Hdrs, Body, Timeout, Config) ->
	Options = [
		{connect_timeout, Timeout}, 
		{recv_timeout, infinity},
		{pool, Config#aws_config.connection_pool}
	],

	case hackney:request(Method, URL, Hdrs, Body, Options) of
		{ok, StatusCode, _RespHeaders, ClientRef} ->
			case hackney:body(ClientRef) of
				{ok, ResultBody} ->
					{ok, {{StatusCode, undefined}, undefined, ResultBody}};
				{error, Reason} ->
					{error, Reason}
			end;
		{error, Reason} ->
			{error, Reason}
	end.