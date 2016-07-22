package;

import kha.System;
import kha.Scheduler;

class Main {
	public static function main() {
		System.init({
			title: "Mountain Lobster",
			width: 960, height: 540
		}, function() {
			var game = new MountainLobster();
			System.notifyOnRender(game.render);
			Scheduler.addTimeTask(game.update, 0, 1 / 60);
		});
	}
}