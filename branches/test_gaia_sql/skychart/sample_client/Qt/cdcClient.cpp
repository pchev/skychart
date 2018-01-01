#include "cdcClient.h"
#include <QtGui>
#include <QHostAddress>

CdcClient::CdcClient()
{
  client = new TcpClient(QHostAddress(QHostAddress::LocalHost), 3292);
  QVBoxLayout *layout = new QVBoxLayout;
  cmdTxt = new QLineEdit;
  sendButton = new QPushButton("Send");
  sendButton->setEnabled(false);
  connectButton = new QPushButton("Connect");
  connectButton->setEnabled(true);
  disconnectButton = new QPushButton("Disconnect");
  disconnectButton->setEnabled(false);
  connect(cmdTxt, SIGNAL(returnPressed()), this, SLOT(sendCmd()));
  connect(sendButton, SIGNAL(clicked()), this, SLOT(sendCmd()));
  connect(connectButton, SIGNAL(clicked()), client, SLOT(connect()));
  connect(disconnectButton, SIGNAL(clicked()), client, SLOT(disconnect()));
  connect(client, SIGNAL(receivedData(const QString &)), this, SLOT(displayMsg(const QString &)));
  connect(client, SIGNAL(connected()), this, SLOT(set_connected()));
  connect(client, SIGNAL(disconnected()), this, SLOT(set_disconnected()));
  display = new QTextEdit();
  status = new QLabel("Not connected");
  layout->addWidget(cmdTxt);
  layout->addWidget(sendButton);
  layout->addWidget(display);
  layout->addWidget(connectButton);
  layout->addWidget(disconnectButton);
  layout->addWidget(status);
  setLayout(layout);
  setWindowTitle("CdC TCP Client");
}

void CdcClient::set_connected()
{
  status->setText("Connected");
  sendButton->setEnabled(true);
  connectButton->setEnabled(false);
  disconnectButton->setEnabled(true);
}

void CdcClient::set_disconnected()
{
  status->setText("Not connected");
  sendButton->setEnabled(false);
  connectButton->setEnabled(true);
  disconnectButton->setEnabled(false);
}

void CdcClient::displayMsg(const QString &msg)
{
  if ( msg[0] != '.' )
    display->insertPlainText("CdC> " + msg);
}


void CdcClient::sendCmd()
{
  QString cmd = cmdTxt->text();
  client->sendData(cmd);
  client->sendData("redraw");
  cmdTxt->setText("");
}

void CdcClient::displayError(const QString &msg)
{
  QMessageBox::critical(this, "CdcClient:", msg);
}

void CdcClient::quitting()
{
  qDebug() << "CdcClient: quitting";
  client->sendData("quit");
  //client->quitting();
}
