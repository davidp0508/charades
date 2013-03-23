%% @author David
%% @doc @todo Add description to player.


-module(player).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1, getUsername/1]).

getUsername(Name) ->
	io:format("Adding user ~p~n", [Name]).

start(Name) ->
	%register(Name, spawn(player, Name, [])) %try to register a user in the system
	case global:register_name(Name, spawn(player, getUsername, [Name])) of
		yes -> 
			io:format("Successful add~n"),
			io:format("The registered names are ~p~n", [global:registered_names()]);
		no -> 
			io:format("Unable to add ~p~n", [Name])
	end.
		

	
%% ====================================================================
%% Internal functions
%% ====================================================================


