#ifndef _tcpClient_h
#define _tcpClient_h

#include <QTcpSocket>
#include <QHostAddress>

class TcpClient : public QObject
{
    Q_OBJECT
public:
  TcpClient(QHostAddress host, int port);
  
  bool isConnected() { return is_connected; }
  QString readLine();
  void sendData(const QString &msg);

signals:
  void receivedData(const QString &msg);
  void errorMsg(const QString &msg);
  void connected();
  void disconnected();

private slots:
    void readData();
    void error(QAbstractSocket::SocketError);
    void set_connected();
    void set_disconnected();
public slots:
    void connect();
    void disconnect();
    void quitting();

private:
    void clearInput();
    QTcpSocket *tcpSocket;
    bool is_connected;
    QHostAddress host;
    int port;
};

#endif
