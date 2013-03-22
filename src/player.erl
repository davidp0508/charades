%% @author David
%% @doc @todo Add description to player.


-module(player).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/1]).

start(Name) ->
	%register(Name, spawn(player, Name, [])) %try to register a user in the system
	global:register_name(Name, spawn(player, Name, [])).
%% ====================================================================
%% Internal functions
%% ====================================================================


