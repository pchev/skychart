#ifndef _cdcClient_h
#define _cdcClient_h

#include "tcpClient.h"
#include <QWidget>

class QTextEdit;
class QPushButton;
class QLineEdit;
class QLabel;

class CdcClient : public QWidget
{
    Q_OBJECT
public:
  CdcClient();
  // ~CdcClient() { quitting(); }

private slots:
    void sendCmd();
    void displayMsg(const QString &);
    void displayError(const QString &);
    void set_connected();
    void set_disconnected();
public slots:
    void quitting();

private:
    TcpClient *client;
    QPushButton *sendButton;
    QPushButton *connectButton;
    QPushButton *disconnectButton;
    QLineEdit *cmdTxt;
    QTextEdit *display;
    QLabel *status;
};

#endif
