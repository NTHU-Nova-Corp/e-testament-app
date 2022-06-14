# e-testament-app
Web app frontend for E-Testament API


1: the session of breadcrumb (will be set in the logic)  
2: the presentation directory to show in 'view' (will be returned to the caller)  
There are 3 way to use the function     
1) get_view_path(breadcrumb: "path1/path2")     
- the breadcrumb associates to directory "presentation/path1/path2.slim" when a slim file and breadcrumb are in the same order     
2) get_view_path(breadcrumb: "path1", in_page: "path1")     
- the breadcrumb does not associate to the directory, such as "presentation/path1/path1.slim" in_page is specified to not duplicate the breadcrumb
3) get_view_path(breadcrumb: "/path1/path2", display: "display information")
- the breadcrumb associates to directory "presentation/path1/path2.slim" but there is information that needs to be showed before the main path breadcrumb will insert display before the last path "/path1/{display information}/path2"