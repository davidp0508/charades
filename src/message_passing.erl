%% @author David
%% @doc @todo Add description to message_passing.
%% @author David Pearson
%% @doc @todo Add description to token_ring.
%% This module inspired by trigonakis.com's Intro to Erlang: Message Passing segment

-module(message_passing).
%-import(player, [start/1]).
-export([unicastSend/1, recvMsg/0, message/2, start/1]).


unicastSend({Name, Node, Payload}) ->
	%{Name, Node, Payload} = Message,
	{Name,Node}!{Payload,node()}.
	%message(Name, testMsg).
	%{_,Name,_} = Message,
	%case lists:member(Name, global:registered_names()) of %make sure it's registered
	%	true -> message(Name, Message);
	%	false -> register(Name, spawn(message_passing, Name, []))
	%figure out the destination name from the Message body and try to send to it.
	%end.


%% multicastSend(Message) ->
%% 	member(Name, global:registered_names()) -> %make sure it's registered
%% 		message(Name, Message); %figure out the destination from the Message body and try to send to it. Make sure it's registered?
%% 		register(Name, spawn(message_passing, Name, [])), %else, register it?
%% 		message(Name, Message)
%% 	,
%% 	foreach(unicastSend(Message), global:registered_names()) -> ok %try to go through all registered processes?
%% 	end.


recvMsg() ->
	%try to receive a message. this probably doesn't happen like this, though.
	io:format("Received a message"), 
	receive
		{Payload, FromName} ->        
		io:format("Got message ~p from ~p!~n", [Payload, FromName]);
		Message -> io:format("Hello World!~n", [])
	end.

message(ToName, Message) ->
	%io:format("The registered names are ~p~n", [global:registered_names()]),
	io:format("The registered names are ~p~n", [registered()]),
    case whereis(ToName) of %case global:whereis_name(ToName) of % Test if the client is running
        undefined ->
            io:format("~p is ~p~n", [ToName, not_logged_on]);
        Pid -> Pid ! {message_to, ToName, Message},
             okman
end.



server_transfer(From, Name, To, Message, User_List) ->
    %% Find the receiver and send the message
    case lists:keysearch(To, 2, User_List) of
        false ->
            From ! {messenger, receiver_not_found};
        {value, {ToPid, To}} ->
            ToPid ! {message_from, Name, Message}, 
            From ! {messenger, sent} 
    end.


getUsername(Name) ->
	io:format("Adding user ~p~n", [Name]).

start(Name) ->
	%case global:register_name(Name, spawn(player, getUsername, [Name])) of
	case register(Name, spawn(message_passing, recvMsg, [])) of
		true -> %yes -> 
			io:format("Successful add~n"),
			io:format("The registered names are ~p~n", [registered()]);
		false -> %no -> 
			io:format("Unable to add ~p~n", [Name])
	end.