%% @author David
%% @doc @todo Add description to message_passing.
%% @author David Pearson
%% @doc @todo Add description to token_ring.
%% This module inspired by trigonakis.com's Intro to Erlang: Message Passing segment

-module(message_passing).
%-export([create_ring/1, connect_ring/1, player/1]). %how to export funcs to be used as interfaces to the class/module


unicastSend(Message) ->
	member(Name, registered()) -> %make sure it's registered
		message(Name, Message), %figure out the destination name from the Message body and try to send to it.
	end.


multicastSend(Message) ->
	member(Name, registered()) -> %make sure it's registered
		message(Name, Message); %figure out the destination from the Message body and try to send to it. Make sure it's registered?
		register(Name, spawn(message_passing, Name, [])), %else, register it?
		message(Name, Message)
	,
	foreach(multicastSend(Message), registered()) -> ok %try to go through all registered processes?
	end.


recvMsg() ->
	%try to receive a message. this probably doesn't happen like this, though. 
	receive

	end.