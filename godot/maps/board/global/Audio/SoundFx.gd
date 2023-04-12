# TODO: this is an autoloaded singleton, so it can be accessed from anywhere,
# but this means that it's not garbage collected, so it will stay in memory
# forever from the start. This is not a problem for now, but it might be in the future.
# If there are many sounds, it will be better to add the sounds to the nodes that need them
# and play them from there.
extends Node

# Sound played when hovering over a card
func hover_click_hand():
	$hover_click01.play()


# Sound played when the player picks a card
func card_in01_hand():
	$card_in01.play()


# Sound played when the player change cards from the hand
func card_in02_hand():
	$card_in02.play()


func card_out01_hand():
	$card_out01.play()


# Sound played when the card enters on planning phase
func card_out02_hand():
	$card_out02.play()
