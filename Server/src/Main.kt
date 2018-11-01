object Main {
	@JvmStatic
	fun main(args: Array<String>) {
		// make a connection to MySQL Server
		val provider = JDBCProvider()
		provider.connection
		// execute the query via connection object
		provider.closeConnection()
	}
}