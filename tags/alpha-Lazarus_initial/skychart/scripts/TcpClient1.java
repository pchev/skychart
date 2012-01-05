/*
 * Created on 9 sept. 2005
 *
 * example program that receive all messages from the program
 * and process the information from each click on the chart.
 * 
*/
package demo;

import net.api.skychart.client.CdcClient;

/**
 * @author Patrick Chevalley
 *
 */
public class TcpClient1 {

	public static void main(String[] args) {
		CdcClient cdc = new CdcClient();
		if (cdc.connected()) {
			String buf,tab,chart,ra,dec,type,desc ;
			String[] rep;
			while ((buf=cdc.readLine())!=null) {
				if (buf.compareTo(".")!=0){  
					rep=buf.split("\t",6);
					if ((rep.length==6)&&(rep[0].compareTo(">")==0)){
						chart=rep[1];
						ra=rep[2];
						dec=rep[3];
						type=rep[4];
						desc=rep[5];
						System.out.println("From "+chart+"  RA:"+ra+" DEC:"+dec+" Type:"+type);
						System.out.println("Desc: "+desc);
					} else {
						System.out.println(buf);
					}
				}				
			}
				
			System.out.println("Exit!");				
		}
						
	}


}
