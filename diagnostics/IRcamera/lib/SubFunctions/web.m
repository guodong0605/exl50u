%WEB Open Web browser on site or files.
%   WEB opens up an empty internal web browser.  The default internal web
%   browser includes a toolbar with standard web browser icons, and an address
%   box showing the current address.
%
%   WEB URL displays the specified URL (Uniform Resource Locator) in an
%   internal web browser window.  If one or more internal web browsers are
%   already running, the last active browser (determined by the last
%   browser which had focus) will be reused.  If the URL is located underneath
%   docroot, then it will automatically be displayed inside the Help
%   browser.  If the file is on the MATLAB path, a fully qualified name is
%   not necessary.  Also, the file can be referenced relative to the
%   current working directory.
%
%   WEB URL -NEW displays the specified URL in a new internal web browser
%   window.
%
%   WEB URL -NOTOOLBAR displays the specified URL in an internal web
%   browser without a toolbar (and address box).
%
%   WEB URL -NOADDRESSBOX displays the specified URL in an internal web
%   browser without an address box (but does include a toolbar with standard
%   web browser icons).
%
%   WEB URL -HELPBROWSER displays the specified URL in the Help browser.
%
%   STAT = WEB(...) -BROWSER returns the status of the WEB command in the
%   variable STAT. STAT = 0 indicates successful execution. STAT = 1
%   indicates
%   that the browser was not found. STAT = 2 indicates that the browser was
%   found, but could not be launched.
%
%   [STAT, BROWSER] = WEB returns the status, and a handle to the last active
%   browser.
%
%   [STAT, BROWSER, URL] = WEB returns the status, a handle to the last active
%   browser, and the URL of the current location.
%
%   WEB URL -BROWSER opens a System Web browser and loads the file or Web site
%   specified in the URL (Uniform Resource Locator).  The URL can be of any form
%   that your browser can support.  Generally, it can specify a local  file or a
%   Web site on the Internet.  On Windows and Macintosh, the Web browser
%   is determined by the operating system.  On UNIX (excluding the Mac), it is
%   determined as specified in the "Web" preferences panel.
%
%   Examples:
%      web file:///disk/dir1/dir2/foo.html
%         opens the file foo.html in an internal browser.
%
%      web('foo.html');
%         opens the file foo.html if it is on the MATLAB path.
%
%      web('html/foo.html');
%         opens the file html/foo.html, which is relative to the current
%         working directory.
%
%      web('text://<html>Hello World</html>');
%         displays the html formatted text inside an internal browser.
%
%      web('http://www.mathworks.com', '-new');
%         loads the MathWorks Web page into a new internal browser.
%
%      web('http://www.mathworks.com', '-new', '-notoolbar');
%         loads the MathWorks Web page into a new internal browser without
%         a toolbar or address box.
%
%      web('file:///disk/helpfile.html', '-helpbrowser');
%         opens the file helpfile.html in the Help browser.
%
%      web('file:///disk/dir1/dir2/foo.html', '-browser');
%         opens the file foo.html in a system browser.
%
%      web mailto:email_address
%         uses your system browser to send mail.
%
%