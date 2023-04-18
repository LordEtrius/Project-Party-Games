@tool
class_name NegativeEnergy
extends Tile

func effect(_board: Board, player: BoardPlayer) -> void:
  player.energy -= 2
  TileEvent.record.emit("%s lost 2 energy" % player.name)
  await player.animate_rotation()
