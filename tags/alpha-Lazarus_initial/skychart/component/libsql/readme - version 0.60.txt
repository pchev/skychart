Release notes on 0.60


This happen to be "stable" version. On my system. No guarantees.

The SQLITE transaction mechanism has changed a little. A transaction no loger involves a thread lock. Threads can share the same file handle safely on windows systems.

Removed a confusing property from the TResultSet class.

Some bugfixes.

Merged more support functions (by pchev. tx!): flush, truncate, lock, vacuum

SQLite best tested currently. MySQL support without real problems. Most recent libmysql.dll ( version 5.0.n) supported.

The components may use some attention. So does the documentation. Volunteer welcome!

It is not multi-platform tested. Notify me of new issues please. Not much changes since last testing.

Next release will contain additional sqlite class that provides a threading mechanism to allow multiple threads on some unix systems redirected to a single thread for the file system to work correctly.
