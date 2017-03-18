/*
 * Created on 9 sept. 2005
 *
 * TCP/IP client function to access Cartes du Ciel from a java client 
 */
package net.api.skychart.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * @author Patrick Chevalley
 *
 * Cartes du Ciel java client class
 * 
 */
public class CdcClient {
	
	private static String crlf = "\r\n"; 
	private String host ="localhost";
	private int port = 3292;	
	private Socket soc = null;
	private OutputStreamWriter writer = null;
	private BufferedReader reader = null;	
	private String errMsg = "";
	
	/**
	 * create a client and connect to the default server hostname and port
	 */
	public CdcClient() {
		connectCDC();
	}
	/**
	 * create a client and connect to the server
	 * @param host The hostname to connect
	 * @param port The port to connect
	 */
	public CdcClient(String host, int port) {
		connectCDC(host, port);
	}

	/**
	 * @return Returns the host.
	 */
	public String getHost() {
		return host;
	}
	/**
	 * @param host The host to set.
	 */
	public void setHost(String host) {
		this.host = host;
	}
	/**
	 * @return Returns the port.
	 */
	public int getPort() {
		return port;
	}
	/**
	 * @param port The port to set.
	 */
	public void setPort(int port) {
		this.port = port;
	}
	
	/**
	 * @return Returns the last error message after a failure.
	 */
	public String lastError() {
		return errMsg;
	}
	/**
	 * Connect to the server 
	 */
	public boolean connectCDC(){
		boolean result = false;
		try {
			soc = new Socket(host,port);
			writer = new OutputStreamWriter(soc.getOutputStream());
			reader = new BufferedReader(new InputStreamReader(soc.getInputStream()));		
			result = (writer != null) & (reader != null);
		} catch (UnknownHostException e) {
			errMsg=e.getMessage();
			System.err.println(errMsg);
		} catch (IOException e) {
			errMsg=e.getMessage();
			System.err.println(errMsg);
		}
		return result;
	}
	
	/**
	 * Close the connection to the server
	 */
	public void closeCDC() {
		try {
			try {
			writeLine("quit");
			}finally{
				if (reader != null) reader.close();
				if (writer != null) writer.close();	
				reader=null;
				writer=null;
			}
		} catch (IOException e) {
			errMsg=e.getMessage();
			System.err.println(errMsg);
		}
	}
	/**
	 * Connect to the specified server
	 * @param host Server hostname
	 * @param port Server port
	 */
	public boolean connectCDC(String host, int port) {
		setHost(host);
		setPort(port);
		return connectCDC();
		
	}
	/**
	 * @return The server is connected
	 */
	public boolean connected() {
		return (writer != null) & (reader != null);
	}
	
	/**
	 * @return A line from the server
	 */
	public String readLine() {
		try {
			return reader.readLine();
		} catch (IOException e) {
			errMsg=e.getMessage();
			System.err.println(errMsg);
			return null;
		}

	}
	/**
	 * Send a command to the server and wait for the response
	 * @param cmd The command to execute
	 * @return The response from the server
	 */
	public String sendCmd(String cmd) {
		String result = null;
		clearInput();
		writeLine(cmd);
		result = readLine();
		return result;
	}

	/**
	 * Clear the input buffer for unprocessed server response
	 */
	private void clearInput() {
		try {
			while (reader.ready()) {
				reader.read();
			}
		} catch (IOException e) {
			errMsg=e.getMessage();
		}
	}
	/**
	 * Send a string to the server
	 */
	private boolean write(String str) {
		boolean result = false;
		try {
			writer.write(str);
			writer.flush();
			result=true;
			return result;
		} catch (IOException e) {
			errMsg=e.getMessage();
			System.err.println(errMsg);
			return result;
		} 

	}
	/**
	 * Send a line to the server
	 */
	private boolean writeLine(String str) {
		return write(str+crlf);
	}
	
}
