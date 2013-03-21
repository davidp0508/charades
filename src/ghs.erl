%% @author David
%% @doc @todo Add description to ghs.


-module(ghs).

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).

ghs_node() ->
	ghs@noidea.


server(Player_List) ->
	receive
		 {From, logon, Name} ->
            New_Player_List = server_logon(From, Name, Player_List),
            server(New_Player_List);
        {From, logoff} ->
            New_Player_List = server_logoff(From, Player_List),
            server(New_Player_List);
        {From, message_to, To, Message} ->
            server_transfer(From, To, Message, Player_List),
            io:format("list is now: ~p~n", [Player_List]),
            server(Player_List)
    end.

%%% Start the server
start_server() ->
    register(ghs, spawn(ghs, server, [[]])).

%%% Server adds a new user to the player list
server_logon(From, Name, Player_List) ->
    %% check if logged on anywhere else
    case lists:keymember(Name, 2, Player_List) of
        true ->
            From ! {ghs, stop, user_exists},  %reject logon
            Player_List;
        false ->
            From ! {ghs, logged_on},
            [{From, Name} | Player_List]        %add user to the list
    end.

%%% Server deletes a user from the user list
server_logoff(From, Player_List) ->
    lists:keydelete(From, 1, Player_List).


%%% Server transfers a message between user
%server_transfer(From, To, Message, Player_List) ->
    %% check that the user is logged on and who he is
%    case lists:keysearch(From, 1, Player_List) of
 %       false ->
  %          From ! {ghs, stop, not_logged_on};
   %     {value, {From, Name}} ->
   %         server_transfer(From, Name, To, Message, Player_List)
   % end.
%%% If the user exists, send the message
%server_transfer(From, Name, To, Message, Player_List) ->
    %% Find the receiver and send the message
%    case lists:keysearch(To, 2, Player_List) of
%        false ->
%            From ! {ghs, receiver_not_found};
%        {value, {ToPid, To}} ->
%%            ToPid ! {message_from, Name, Message}, 
 %           From ! {ghs, sent} 
 %   end.

			
join(Name) ->
	case whereis(player) of %need to register all nodes as "player" 
		undefined -> 
			register(player, spawn(ghs, client, [ghs_node(), Name]));
		_ -> already_in_game %this node is already in the game
	end.


quit() ->
	player ! quit_game. %definitely needs more logic

%% ====================================================================
%% Internal functions
%% ====================================================================


