/*
 * Created on 9 sept. 2005
 *
 * example program to send sequential command to the program
 * 
 */
package demo;

import net.api.skychart.client.CdcClient;

/**
 * @author Patrick Chevalley
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TcpClient2 {
	

	public static void main(String[] args) {
		CdcClient cdc = new CdcClient();
		if (cdc.connected()) {
			System.out.println(cdc.readLine());
			System.out.println(cdc.sendCmd("newchart test"));
			System.out.println(cdc.sendCmd("selectchart test"));
			System.out.println(cdc.sendCmd("setproj equat"));
			System.out.println(cdc.sendCmd("redraw"));
			System.out.println(cdc.sendCmd("search M37"));
			System.out.println(cdc.sendCmd("setfov 03d0m0s"));
			System.out.println(cdc.sendCmd("redraw"));
			cdc.closeCDC();
		}
		
	}


}
