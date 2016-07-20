package;

import kha.System;

class Main {
	public static function main() {
		System.init({
			title: "Mountain Lobster",
			width: 960, height: 540
		}, function() {
			new MountainLobster();
		});
	}
}