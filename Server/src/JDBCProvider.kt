import java.sql.Connection
import java.sql.DriverManager
import java.sql.SQLException
import java.util.logging.Level
import java.util.logging.Logger

class JDBCProvider @Throws(SQLException::class)
constructor() {
	var connection: Connection? = null
		private set

	init {
		openConnection()
	}

	@Throws(SQLException::class)
	private fun openConnection() {
		val username = "root"
		val password = "UltraSicheresPasswort123"

		val url = "jdbc:mysql://" + "localhost" + ":3306/" + "ESTP_2018"

		try {
			Class.forName("com.mysql.jdbc.Driver")
			this.connection = DriverManager.getConnection(url, username, password)
		} catch (ex: SQLException) {
			Logger.getLogger(JDBCProvider::class.java.name).log(Level.SEVERE, null, ex)
			throw ex
		} catch (ex: ClassNotFoundException) {
			Logger.getLogger(JDBCProvider::class.java.name).log(Level.SEVERE, null, ex)
		}

	}

	@Throws(SQLException::class)
	fun closeConnection() {
		try {
			connection?.close()
		} catch (ex: SQLException) {
			Logger.getLogger(JDBCProvider::class.java.name).log(Level.SEVERE, null, ex)
			throw ex
		}

	}
}