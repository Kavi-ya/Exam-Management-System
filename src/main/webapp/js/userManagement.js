/**
 * User Management JavaScript
 * Handles client-side operations for the User Management page
 * Last Updated: 2025-04-16
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize DataTable
    const userTable = $('#usersTable').DataTable({
        responsive: true,
        pageLength: 10,
        order: [[0, 'desc']], // Sort by ID descending by default
        language: {
            search: "Search:",
            paginate: {
                first: "First",
                last: "Last",
                next: '<i class="fas fa-chevron-right"></i>',
                previous: '<i class="fas fa-chevron-left"></i>'
            }
        }
    });
    
    // Load users when the page loads
    loadUsers();
    
    // DOM elements
    const refreshBtn = document.getElementById('refreshBtn');
    const addUserBtn = document.getElementById('addUserBtn');
    const viewUserModal = document.getElementById('viewUserModal');
    const editUserModal = document.getElementById('editUserModal');
    const addUserModal = document.getElementById('addUserModal');
    const deleteUserModal = document.getElementById('deleteUserModal');
    const editUserForm = document.getElementById('editUserForm');
    const addUserForm = document.getElementById('addUserForm');
    const deleteUserForm = document.getElementById('deleteUserForm');
	
	// Update session timestamp
	const sessionInfoEl = document.querySelector('.session-info');
	if (sessionInfoEl) {
	    sessionInfoEl.innerHTML = '<i class="fas fa-clock me-1"></i> Session: 2025-04-16 18:39:39';
	}
    
    // Close buttons for modals
    document.querySelectorAll('.close, .close-modal').forEach(function(closeBtn) {
        closeBtn.addEventListener('click', function() {
            const modal = closeBtn.closest('.modal');
            if (modal) modal.style.display = 'none';
        });
    });
    
    // Close modal when clicking outside of it
    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
        }
    });
    
    // Refresh button functionality
    refreshBtn.addEventListener('click', function() {
        loadUsers();
    });
    
    // Add User Button Functionality
    addUserBtn.addEventListener('click', function() {
        // Reset form first
        if (addUserForm) addUserForm.reset();
        
        // Show the modal
        addUserModal.style.display = 'block';
        
        // Get the role selector and set initial role fields
        const addRoleSelect = document.getElementById('addRole');
        if (addRoleSelect) {
            // Force a reset of the role to blank
            addRoleSelect.value = '';
            
            // Initialize fields correctly
            toggleRoleFields('add');
        }
    });
    
    // Add event delegation for view, edit, delete buttons
    document.addEventListener('click', function(e) {
        // View button
        if (e.target.closest('.view-btn')) {
            const btn = e.target.closest('.view-btn');
            const userId = btn.getAttribute('data-userid');
            viewUser(userId);
        }
        
        // Edit button
        if (e.target.closest('.edit-btn')) {
            const btn = e.target.closest('.edit-btn');
            const userId = btn.getAttribute('data-userid');
            editUser(userId);
        }
        
        // Delete button
        if (e.target.closest('.delete-btn')) {
            const btn = e.target.closest('.delete-btn');
            const userId = btn.getAttribute('data-userid');
            document.getElementById('deleteUserId').value = userId;
            deleteUserModal.style.display = 'block';
        }
    });
    
    // Cancel delete button
    const cancelDeleteBtn = document.getElementById('cancelDelete');
    if (cancelDeleteBtn) {
        cancelDeleteBtn.addEventListener('click', function() {
            deleteUserModal.style.display = 'none';
        });
    }
    
    // Add custom submit handler for edit form
    if (editUserForm) {
        editUserForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Perform standard form submit (not AJAX)
            console.log("Submitting edit form via standard method");
            this.submit();
        });
    }
    
    // Add custom submit handler for add form
    if (addUserForm) {
        addUserForm.addEventListener('submit', function(e) {
            if (!validateAddUserForm()) {
                e.preventDefault();
                return false;
            }
            
            // Perform standard form submit (not AJAX)
            console.log("Submitting add form via standard method");
        });
    }
    
    // Delete user form submission
    if (deleteUserForm) {
        deleteUserForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Perform standard form submit (not AJAX)
            console.log("Submitting delete form via standard method");
            this.submit();
        });
    }
    
    // Set up role change handlers
    const addRole = document.getElementById('addRole');
    if (addRole) {
        addRole.addEventListener('change', function() {
            toggleRoleFields('add');
        });
    }
    
    const editRole = document.getElementById('editRole');
    if (editRole) {
        editRole.addEventListener('change', function() {
            toggleRoleFields('edit');
        });
    }
    
    // Initialize role fields on page load
    if (editRole) {
        toggleRoleFields('edit');
    }

    // Update session information
    updateSessionInfo();
});

/**
 * Update the session information with current date and user login
 */
function updateSessionInfo() {
    const sessionInfoEl = document.querySelector('.session-info');
    if (sessionInfoEl) {
        sessionInfoEl.innerHTML = '<i class="fas fa-clock me-1"></i> Session: 2025-04-16 18:03:27';
    }
    
    const userLoginEl = document.querySelector('.text-muted');
    if (userLoginEl) {
        userLoginEl.textContent = 'IT24102083';
    }
}

/**
 * Show a toast notification instead of an alert
 * @param {string} message - The message to display
 * @param {string} type - The type of toast (success, error, warning, info)
 */
function showToast(message, type = 'info') {
    // Define colors based on type
    const colors = {
        success: '#28a745',
        error: '#dc3545',
        warning: '#ffc107',
        info: '#17a2b8'
    };
    
    // Create toast element
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.style.backgroundColor = '#ffffff';
    toast.style.borderLeft = `4px solid ${colors[type] || colors.info}`;
    
    // Toast content
    toast.innerHTML = `
        <div class="toast-header" style="padding: 0.5rem 1rem; border-bottom: 1px solid #f0f0f0;">
            <strong style="color: ${colors[type] || colors.info};">${type.charAt(0).toUpperCase() + type.slice(1)}</strong>
            <button type="button" class="btn-close btn-close-toast" style="margin-left: auto; font-size: 0.8rem;"></button>
        </div>
        <div class="toast-body" style="padding: 0.75rem 1rem;">
            ${message}
        </div>
    `;
    
    // Add to container
    const container = document.getElementById('toast-container');
    if (!container) {
        const newContainer = document.createElement('div');
        newContainer.id = 'toast-container';
        newContainer.style.position = 'fixed';
        newContainer.style.top = '15px';
        newContainer.style.right = '15px';
        newContainer.style.zIndex = '9999';
        document.body.appendChild(newContainer);
        newContainer.appendChild(toast);
    } else {
        container.appendChild(toast);
    }
    
    // Add close button functionality
    toast.querySelector('.btn-close-toast').addEventListener('click', function() {
        removeToast(toast);
    });
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        removeToast(toast);
    }, 3000);
}

/**
 * Remove a toast notification with animation
 * @param {HTMLElement} toast - The toast element to remove
 */
function removeToast(toast) {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    toast.style.transition = 'all 0.3s ease';
    
    setTimeout(() => {
        if (toast.parentNode) {
            toast.parentNode.removeChild(toast);
        }
    }, 300);
}

/**
 * Toggle role-specific fields based on selected role
 * @param {string} prefix - The form prefix ('add' or 'edit')
 */
function toggleRoleFields(prefix = 'add') {
    const roleSelect = document.getElementById(prefix + 'Role');
    if (!roleSelect) return;
    
    const role = roleSelect.value;
    const studentFields = document.getElementById(prefix + 'StudentFields');
    const teacherFields = document.getElementById(prefix + 'TeacherFields');
    
    if (!studentFields || !teacherFields) return;
    
    // Hide both sections initially
    studentFields.style.display = 'none';
    teacherFields.style.display = 'none';
    
    // Show the relevant section based on selected role
    if (role === 'student') {
        studentFields.style.display = 'block';
    } else if (role === 'teacher') {
        teacherFields.style.display = 'block';
    }
}

/**
 * Load all users and refresh the table
 */
async function loadUsers() {
    try {
        const response = await fetch('userManagement');
        if (!response.ok) {
            throw new Error('Failed to fetch users');
        }
        
        const users = await response.json();
        const table = $('#usersTable').DataTable();
        
        // Clear the table
        table.clear();
        
        // Add the users to the table
        users.forEach(user => {
            // Create role badge with color based on role
            let roleBadge = `<span class="role-badge role-${user.role || 'user'}">${user.role || 'User'}</span>`;
            
            // Create status badge
            let statusBadge = `<span class="status-badge status-${(user.status || '').toLowerCase()}">${user.status || 'Unknown'}</span>`;
            
            // Format the user's full name
            let fullName = `${user.firstName || ''} ${user.lastName || ''}`;
            if (!fullName.trim()) fullName = 'N/A';
            
            // Format last login date
            let lastLogin = formatDate(user.lastLogin);
            
            // Create action buttons HTML
            let actionButtons = `
                <div class="action-btns">
                    <button type="button" class="btn btn-sm btn-outline-primary view-btn" data-userid="${user.userId}" title="View">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-warning edit-btn" data-userid="${user.userId}" title="Edit">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-danger delete-btn" data-userid="${user.userId}" title="Delete">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            `;
            
            // Add row to table
            table.row.add([
                user.userId || 'N/A',
                user.username || 'N/A',
                user.email || 'N/A',
                fullName,
                roleBadge,
                statusBadge,
                lastLogin,
                actionButtons
            ]);
        });
        
        // Redraw the table
        table.draw();
        
        // Update the timestamp in the top bar
        updateSessionInfo();
    } catch (error) {
        console.error('Error loading users:', error);
        showToast('Failed to load users. Please try again.', 'error');
    }
}

/**
 * View user details
 * @param {string} userId - The ID of the user to view
 */
function viewUser(userId) {
    fetch(`userManagement/${userId}`)
        .then(response => {
            if (!response.ok) throw new Error('User not found');
            return response.json();
        })
        .then(user => {
            // Basic Information
            document.getElementById('viewUserId').textContent = user.userId || 'N/A';
            document.getElementById('viewUsername').textContent = user.username || 'N/A';
            document.getElementById('viewEmail').textContent = user.email || 'N/A';
            document.getElementById('viewFirstName').textContent = user.firstName || 'N/A';
            document.getElementById('viewLastName').textContent = user.lastName || 'N/A';
            
            // Role Information with enhanced styling
            const roleElement = document.getElementById('viewRole');
            if (roleElement) {
                roleElement.textContent = user.role || 'N/A';
                roleElement.className = 'detail-value role';
            }
            
            // Status with dynamic styling
            const statusElement = document.getElementById('viewStatus');
            if (statusElement) {
                statusElement.textContent = user.status || 'N/A';
                statusElement.className = `detail-value status status-${(user.status || '').toLowerCase()}`;
            }
            
            // Last Login with formatted date
            const lastLoginElement = document.getElementById('viewLastLogin');
            if (lastLoginElement) {
                lastLoginElement.textContent = formatDate(user.				                lastLogin);
				            }

				            // Handle role-specific fields
				            const studentFields = document.getElementById('viewStudentFields');
				            const teacherFields = document.getElementById('viewTeacherFields');
				            
				            // Hide both sections initially
				            if (studentFields) studentFields.style.display = 'none';
				            if (teacherFields) teacherFields.style.display = 'none';

				            // Show and populate relevant section
				            if (user.role === 'student' && user.studentDetails && studentFields) {
				                studentFields.style.display = 'block';
				                const studentFieldMappings = {
				                    'viewCourse': 'course',
				                    'viewSemester': 'semester',
				                    'viewEnrollmentNo': 'enrollmentNumber',
				                    'viewGradYear': 'graduationYear'
				                };

				                Object.entries(studentFieldMappings).forEach(([elementId, dataKey]) => {
				                    const element = document.getElementById(elementId);
				                    if (element) {
				                        element.textContent = user.studentDetails[dataKey] || 'N/A';
				                    }
				                });
				            } else if (user.role === 'teacher' && user.teacherDetails && teacherFields) {
				                teacherFields.style.display = 'block';
				                const teacherFieldMappings = {
				                    'viewEmployeeId': 'employeeId',
				                    'viewDepartment': 'department',
				                    'viewDesignation': 'designation'
				                };

				                Object.entries(teacherFieldMappings).forEach(([elementId, dataKey]) => {
				                    const element = document.getElementById(elementId);
				                    if (element) {
				                        element.textContent = user.teacherDetails[dataKey] || 'N/A';
				                    }
				                });
				            }

				            // Show modal
				            const modal = document.getElementById('viewUserModal');
				            if (modal) {
				                modal.style.display = 'block';
				            }
				        })
				        .catch(error => {
				            console.error('Error fetching user details:', error);
				            showToast('Failed to load user details. Please try again.', 'error');
				        });
				}

				/**
				 * Prepare edit user form
				 * @param {string} userId - The ID of the user to edit
				 */
				function editUser(userId) {
				    fetch(`userManagement/${userId}`)
				        .then(response => {
				            if (!response.ok) {
				                throw new Error('User not found');
				            }
				            return response.json();
				        })
				        .then(user => {
				            // Populate the form with user data
				            document.getElementById('editUserId').value = user.userId;
				            document.getElementById('editUsername').value = user.username || '';
				            document.getElementById('editEmail').value = user.email || '';
				            document.getElementById('editFirstName').value = user.firstName || '';
				            document.getElementById('editLastName').value = user.lastName || '';
				            document.getElementById('editRole').value = user.role || 'user';
				            document.getElementById('editStatus').value = user.status || 'active';
				            
				            // Clear password field - we don't want to show or update password unless explicitly entered
				            document.getElementById('editPassword').value = '';
				            
				            // Handle role-specific fields AFTER setting the role value
				            if (user.role === 'student' && user.studentDetails) {
				                document.getElementById('editCourse').value = user.studentDetails.course || '';
				                document.getElementById('editSemester').value = user.studentDetails.semester || '';
				                document.getElementById('editEnrollmentNo').value = user.studentDetails.enrollmentNumber || '';
				                document.getElementById('editGradYear').value = user.studentDetails.graduationYear || '';
				            } else if (user.role === 'teacher' && user.teacherDetails) {
				                document.getElementById('editEmployeeId').value = user.teacherDetails.employeeId || '';
				                document.getElementById('editDepartment').value = user.teacherDetails.department || '';
				                document.getElementById('editDesignation').value = user.teacherDetails.designation || '';
				            }
				            
				            // Toggle fields AFTER setting all values
				            toggleRoleFields('edit');
				            
				            // Display the modal
				            const modal = document.getElementById('editUserModal');
				            if (modal) {
				                modal.style.display = 'block';
				            }
				        })
				        .catch(error => {
				            console.error('Error fetching user details for edit:', error);
				            showToast('Failed to load user details for editing.', 'error');
				        });
				}

				/**
				 * Format date string to a readable format
				 * @param {string} dateString - ISO date string
				 * @return {string} Formatted date string
				 */
				function formatDate(dateString) {
				    if (!dateString) return 'N/A';
				    
				    try {
				        const date = new Date(dateString);
				        // Check if date is valid
				        if (isNaN(date.getTime())) {
				            return 'N/A';
				        }
				        return date.toLocaleString();
				    } catch (error) {
				        return 'N/A';
				    }
				}

				/**
				 * Validate the add user form
				 * @return {boolean} Whether form is valid
				 */
				function validateAddUserForm() {
				    const form = document.getElementById('addUserForm');
				    const username = form.querySelector('[name="username"]').value.trim();
				    const email = form.querySelector('[name="email"]').value.trim();
				    const password = form.querySelector('[name="password"]').value;
				    const role = form.querySelector('[name="role"]').value;
				    let isValid = true;
				    const errors = [];
				    
				    if (!username) {
				        errors.push("Username is required");
				        isValid = false;
				    }
				    
				    if (!email) {
				        errors.push("Email is required");
				        isValid = false;
				    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
				        errors.push("Invalid email format");
				        isValid = false;
				    }
				    
				    if (!password || password.length < 8) {
				        errors.push("Password must be at least 8 characters");
				        isValid = false;
				    }
				    
				    if (!role) {
				        errors.push("Role selection is required");
				        isValid = false;
				    }
				    
				    // Role-specific validation
				    if (role === 'student') {
				        if (!form.querySelector('[name="course"]').value.trim()) {
				            errors.push("Course is required for students");
				            isValid = false;
				        }
				        if (!form.querySelector('[name="enrollmentNumber"]').value.trim()) {
				            errors.push("Enrollment Number is required for students");
				            isValid = false;
				        }
				    } else if (role === 'teacher') {
				        if (!form.querySelector('[name="employeeId"]').value.trim()) {
				            errors.push("Employee ID is required for teachers");
				            isValid = false;
				        }
				        if (!form.querySelector('[name="department"]').value.trim()) {
				            errors.push("Department is required for teachers");
				            isValid = false;
				        }
				    }
				    
				    if (!isValid) {
				        showToast('Please correct form errors:\n• ' + errors.join('\n• '), 'error');
				    }
				    
				    return isValid;
				}

				// Update session information when the script loads
				document.addEventListener('DOMContentLoaded', function() {
				    // Update session timestamp and user login
				    const sessionInfoEl = document.querySelector('.session-info');
				    if (sessionInfoEl) {
				        sessionInfoEl.innerHTML = '<i class="fas fa-clock me-1"></i> Session: 2025-04-16 18:09:12';
				    }
				    
				    const userLoginEl = document.querySelector('.text-muted');
				    if (userLoginEl) {
				        userLoginEl.textContent = 'IT24102083';
				    }
				});