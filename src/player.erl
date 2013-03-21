%% @author David
%% @doc @todo Add description to player.


-module(player).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1]).

start(Name) ->
	register(Name, spawn(player, Name, [])) %try to register a user in the system?

%% ====================================================================
%% Internal functions
%% ====================================================================


