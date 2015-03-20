package net.multipaint

import hr.ngs.patterns._

object SystemConfiguration {
	def initialize(container: IContainer) {	
		MultiPaint.postgres.initialize(container)
		Security.postgres.initialize(container)
	}
}