@tool
class_name PositiveEnergy
extends Tile

func effect(_board: Board, player: BoardPlayer) -> void:
  player.score.positive_energy += 3
  TileEvent.record.emit("%s gained 3 positive energy" % player.name)
  await player.animate_scale()
