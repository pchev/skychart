// tear.cpp : implements the TEAR console application
//
// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1997 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and related
// electronic documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.

#include <afx.h>
#include <afxwin.h>
#include <afxinet.h>

// tear.h : class definitions for CTearSession and CTearException
//
// This is a part of the Microsoft Foundation Classes C++ library.
// Copyright (C) 1997 Microsoft Corporation
// All rights reserved.
//
// This source code is only intended as a supplement to the
// Microsoft Foundation Classes Reference and related
// electronic documentation provided with the library.
// See these sources for detailed information regarding the
// Microsoft Foundation Classes product.

// Created by Mike Blaszczak.

class CTearSession : public CInternetSession
{
public:
   CTearSession(LPCTSTR pszAppName, int nMethod);
   virtual void OnStatusCallback(DWORD dwContext, DWORD dwInternetStatus,
      LPVOID lpvStatusInfomration, DWORD dwStatusInformationLen);
};


class CTearException : public CException
{
   DECLARE_DYNCREATE(CTearException)

public:
   CTearException(int nCode = 0);
   ~CTearException() { }

   int m_nErrorCode;
};

#include <iostream.h>
#include <stdlib.h>

/////////////////////////////////////////////////////////////////////////////
// Globals

BOOL    bProgressMode = FALSE;


/////////////////////////////////////////////////////////////////////////////
// CTearSession object

// TEAR wants to use its own derivative of the CInternetSession class
// just so it can implement an OnStatusCallback() override.

CTearSession::CTearSession(LPCTSTR pszAppName, int nMethod)
   : CInternetSession(pszAppName, 1, nMethod)
{
}

void CTearSession::OnStatusCallback(DWORD /* dwContext */, DWORD dwInternetStatus,
   LPVOID /* lpvStatusInfomration */, DWORD /* dwStatusInformationLen */)
{
   if (!bProgressMode)
      return;

   if (dwInternetStatus == INTERNET_STATUS_CONNECTED_TO_SERVER)
      cerr << _T("Connection made!") << endl;
}

/////////////////////////////////////////////////////////////////////////////
// CTearException -- used if something goes wrong for us

// TEAR will throw its own exception type to handle problems it might
// encounter while fulfilling the user's request.

IMPLEMENT_DYNCREATE(CTearException, CException)

CTearException::CTearException(int nCode)
   : m_nErrorCode(nCode)
{
}

void ThrowTearException(int nCode)
{
   CTearException* pEx = new CTearException(nCode);
   throw pEx;
}

/////////////////////////////////////////////////////////////////////////////
// Routines


/////////////////////////////////////////////////////////////////////////////
// The main() Thang
int grab_via_http( const char *url, const char *output_file_name,
                           int32_t *bytes_read)
{
   int nRetCode = 0;

   CTearSession session(_T("TEAR - MFC Sample App"), PRE_CONFIG_INTERNET_ACCESS);
   CHttpConnection* pServer = NULL;
   CHttpFile* pFile = NULL;
   DWORD dwHttpRequestFlags =
         INTERNET_FLAG_EXISTING_CONNECT | INTERNET_FLAG_NO_AUTO_REDIRECT;
   const TCHAR szHeaders[] =
      _T("Accept: text/*\r\nUser-Agent: MFC_Tear_Sample\r\n");

   try
   {
      // check to see if this is a reasonable URL

      CString strServerName;
      CString strObject;
      INTERNET_PORT nPort;
      DWORD dwServiceType;

      if (!AfxParseURL(url, dwServiceType, strServerName, strObject, nPort) ||
         dwServiceType != INTERNET_SERVICE_HTTP)
      {
//       cerr << _T("Error: can only use URLs beginning with http://") << endl;
         ThrowTearException(1);
      }

      if (bProgressMode)
      {
//       cerr << _T("Opening Internet...");
         VERIFY(session.EnableStatusCallback(TRUE));
      }

      pServer = session.GetHttpConnection(strServerName, nPort);

      pFile = pServer->OpenRequest(CHttpConnection::HTTP_VERB_GET,
         strObject, NULL, 1, NULL, NULL, dwHttpRequestFlags);
      pFile->AddRequestHeaders(szHeaders);
      pFile->SendRequest();

      DWORD dwRet;
      pFile->QueryInfoStatusCode(dwRet);

      // if access was denied, prompt the user for the password

      if (dwRet == HTTP_STATUS_DENIED)
      {
         DWORD dwPrompt;
         dwPrompt = pFile->ErrorDlg(NULL, ERROR_INTERNET_INCORRECT_PASSWORD,
            FLAGS_ERROR_UI_FLAGS_GENERATE_DATA | FLAGS_ERROR_UI_FLAGS_CHANGE_OPTIONS, NULL);

         // if the user cancelled the dialog, bail out

         if (dwPrompt != ERROR_INTERNET_FORCE_RETRY)
         {
//          cerr << _T("Access denied: Invalid password\n");
            ThrowTearException(1);
         }

         pFile->SendRequest();
         pFile->QueryInfoStatusCode(dwRet);
      }

      CString strNewLocation;
      pFile->QueryInfo(HTTP_QUERY_RAW_HEADERS_CRLF, strNewLocation);

      // were we redirected?
      // these response status codes come from WININET.H

      if (dwRet == HTTP_STATUS_MOVED ||
         dwRet == HTTP_STATUS_REDIRECT ||
         dwRet == HTTP_STATUS_REDIRECT_METHOD)
      {
         CString strNewLocation;
         pFile->QueryInfo(HTTP_QUERY_RAW_HEADERS_CRLF, strNewLocation);

         int nPlace = strNewLocation.Find(_T("Location: "));
         if (nPlace == -1)
         {
//          cerr << _T("Error: Site redirects with no new location") << endl;
            ThrowTearException(2);
         }

         strNewLocation = strNewLocation.Mid(nPlace + 10);
         nPlace = strNewLocation.Find('\n');
         if (nPlace > 0)
            strNewLocation = strNewLocation.Left(nPlace);

         // close up the redirected site

         pFile->Close();
         delete pFile;
         pServer->Close();
         delete pServer;

//       if (bProgressMode)
//       {
//          cerr << _T("Caution: redirected to ");
//          cerr << (LPCTSTR) strNewLocation << endl;
//       }

         // figure out what the old place was
         if (!AfxParseURL(strNewLocation, dwServiceType, strServerName, strObject, nPort))
         {
//          cerr << _T("Error: the redirected URL could not be parsed.") << endl;
            ThrowTearException(2);
         }

         if (dwServiceType != INTERNET_SERVICE_HTTP)
         {
//          cerr << _T("Error: the redirected URL does not reference a HTTP resource.") << endl;
            ThrowTearException(2);
         }

         // try again at the new location
         pServer = session.GetHttpConnection(strServerName, nPort);
         pFile = pServer->OpenRequest(CHttpConnection::HTTP_VERB_GET,
            strObject, NULL, 1, NULL, NULL, dwHttpRequestFlags);
         pFile->AddRequestHeaders(szHeaders);
         pFile->SendRequest();

         pFile->QueryInfoStatusCode(dwRet);
         if (dwRet != HTTP_STATUS_OK)
         {
//          cerr << _T("Error: Got status code ") << dwRet << endl;
            ThrowTearException(2);
         }
      }

//    cerr << _T("Status Code is ") << dwRet << endl;

      TCHAR sz[1024];
      int nRead;
      FILE *ofile = fopen( output_file_name, "wb");

      while( (nRead = pFile->Read( sz, 1024)) > 0)
         {
         fwrite( sz, 1, nRead, ofile);
//       printf( ".");
         if( bytes_read)
            *bytes_read += nRead;
         }
      fclose( ofile);

      pFile->Close();
      pServer->Close();
   }
   catch (CInternetException* pEx)
   {
      // catch errors from WinINet

      TCHAR szErr[1024];
      pEx->GetErrorMessage(szErr, 1024);

//    cerr << _T("Error: (") << pEx->m_dwError << _T(") ");
//    cerr << szErr << endl;

      nRetCode = 2;
      pEx->Delete();
   }
   catch (CTearException* pEx)
   {
      // catch things wrong with parameters, etc

      nRetCode = pEx->m_nErrorCode;
      TRACE1("Error: Exiting with CTearException(%d)\n", nRetCode);
      pEx->Delete();
   }

   if (pFile != NULL)
      delete pFile;
   if (pServer != NULL)
      delete pServer;
   session.Close();

   return nRetCode;
}

#ifdef EXAMPLE_USAGE
int main(int argc, char* argv[])
{
   int rval;

   if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
      {
      cerr << _T("MFC Failed to initialize.\n");
      rval = 1;
      }
   else
      rval = grab_via_http( argv[1], argv[2]. NULL);
   printf( "Returned: %d\n", rval);
   return( rval);
}
#endif
