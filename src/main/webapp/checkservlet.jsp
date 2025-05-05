<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Servlet Check</title>
</head>
<body>
    <h1>Servlet Mapping Test</h1>
    <div id="result">Checking servlet mappings...</div>
    
    <script>
        // Simple function to check URL and add result to page
        function checkServlet(url, displayName) {
            var resultDiv = document.getElementById('result');
            
            fetch(url, {method: 'HEAD'})
                .then(function(response) {
                    if(response.ok) {
                        resultDiv.innerHTML += "<p>" + displayName + ": ✓ Working!</p>";
                    } else {
                        resultDiv.innerHTML += "<p>" + displayName + ": ✗ Error: " + response.status + "</p>";
                    }
                })
                .catch(function(error) {
                    resultDiv.innerHTML += "<p>" + displayName + ": ✗ Error: " + error.message + "</p>";
                });
        }
        
        // Check each servlet URL
        checkServlet('questionSave', 'Question Save Servlet');
        checkServlet('questionGet', 'Question Get Servlet');
        checkServlet('questionList', 'Question List Servlet');
        checkServlet('questionDelete', 'Question Delete Servlet');
    </script>
</body>
</html>