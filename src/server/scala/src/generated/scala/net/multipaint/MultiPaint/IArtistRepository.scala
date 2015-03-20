package net.multipaint.MultiPaint

import hr.ngs.patterns._



trait IArtistRepository 	extends IRepository[net.multipaint.MultiPaint.Artist]	with IPersistableRepository[net.multipaint.MultiPaint.Artist] {
	
	def ActiveUsers(Since: org.joda.time.DateTime): IndexedSeq[net.multipaint.MultiPaint.Artist]
}
