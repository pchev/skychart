#include "tcpClient.h"

TcpClient::TcpClient(QHostAddress host_, int port_)
{
  tcpSocket = new QTcpSocket();
  QObject::connect(tcpSocket, SIGNAL(readyRead()), this, SLOT(readData()));
  QObject::connect(tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(error(QAbstractSocket::SocketError)));
  QObject::connect(tcpSocket, SIGNAL(connected()), this, SLOT(set_connected()));
  QObject::connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(set_disconnected()));
  host = host_;
  port = port_;
  connect();
}

void TcpClient::connect()
{
  if ( ! isConnected() ) 
    tcpSocket->connectToHost(host, port);
}

void TcpClient::disconnect()
{
  if ( isConnected() ) 
    sendData("quit");
    //tcpSocket->close();
    tcpSocket->disconnectFromHost();
}

void TcpClient::readData()
{
    QTextStream in(tcpSocket);

    if ( tcpSocket->canReadLine() )  {
      QString s = tcpSocket->readLine();
      emit receivedData(s);
    }
}

void TcpClient::clearInput()
{
    QTextStream in(tcpSocket);

    while ( tcpSocket->canReadLine() )  {
      QString s = tcpSocket->readLine();
    }
}

void TcpClient::sendData(const QString &msg)
{
  QTextStream out(tcpSocket);
  QString data = msg + "\r\n";

  out << data << endl;
}

void TcpClient::set_connected()
{
  is_connected = true;
  emit connected();
}

void TcpClient::set_disconnected()
{
  is_connected = false;
  emit disconnected();
}


void TcpClient::error(QAbstractSocket::SocketError socketError)
{
    switch (socketError) {
    case QAbstractSocket::RemoteHostClosedError:
        break;
    case QAbstractSocket::HostNotFoundError:
      emit errorMsg("Host not found");
      break;
    case QAbstractSocket::ConnectionRefusedError:
      emit errorMsg("Connection refused by peer");
      break;
    default:
      emit errorMsg(tcpSocket->errorString());
      break;
    }
}

void TcpClient::quitting()
{
  if ( isConnected() ) {
    //qDebug("TcpClient::quitting");
    // Should we do sth special here ???
  }
}
