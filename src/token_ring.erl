%% @author David Pearson
%% @doc @todo Add description to token_ring.
%% This module inspired by trigonakis.com's Intro to Erlang: Message Passing segment

-module(token_ring).
%-export([create_ring/1, connect_ring/1, player/1]). %how to export funcs to be used as interfaces to the class/module


%% create_ring(Num_players) when is_integer(Num_players), Num_players > 1 -> %don't build ring until at least two players, obviously
%% 	Players = [spawn(?MODULE, player, [Name, self()]) || ID <- lists:seq(1, Num_players)],
%% 	token_ring:connect_ring(Players),
%% 	hd(Players) ! {token}.


election(Name) -> true. %placeholder for now


connect_ring(Player = [Hd | _]) -> %creates the logical structure from the list of current players
	connect_ring_(Player ++ [Hd]). %fakes a connection between the last element and the head

connect_ring_([]) ->
	connected;
connect_ring_([_]) ->
	connected;
connect_ring_([Pl1, Pl2 | Players]) ->
	Pl1 ! {self(), connect_ring, Pl2},
	connect_ring_([Pl2 | Players]).


player(Name) ->
	receive
		{connect, Next_player} ->
			player(Name, Next_player)
	end.


player(Name, Next_player) ->
	receive
		{token} ->
			if
				timeout -> %not sure if this is how we should do it?
					election(Name); %no freaking clue...
				true ->
				  case erlang:is_process_alive(Next_player) of
					  true ->
						  Next_player ! {token};
					  _ ->
						  ok %we'll need to possibly handle recovery at this point...
				  end,
				  done
			end
	end.
				  