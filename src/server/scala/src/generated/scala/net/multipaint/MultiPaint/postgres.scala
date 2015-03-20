package net.multipaint
package MultiPaint

import hr.ngs.patterns._

package object postgres {
	def initialize(container: IContainer) {
		val locator = container[IServiceLocator]
		val postgresUtils = locator.resolve[PostgresUtils]
		
		net.multipaint.MultiPaint.postgres.ArtistConverter.initializeProperties(postgresUtils) 
		container.register[net.multipaint.MultiPaint.postgres.ArtistRepository, net.multipaint.MultiPaint.IArtistRepository]
		container.register[net.multipaint.MultiPaint.postgres.ArtistRepository, IRepository[net.multipaint.MultiPaint.Artist]]
		container.register[net.multipaint.MultiPaint.postgres.ArtistRepository, IPersistableRepository[net.multipaint.MultiPaint.Artist]]
	}
}