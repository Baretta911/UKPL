<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Student Status Evaluator - Copilot Instructions

This is a React.js application for evaluating student status based on academic criteria.

## Project Context
- **Framework**: React.js with Vite
- **Language**: JavaScript (JSX)
- **Purpose**: Evaluate student status based on attendance, grades, certification, and administrative completeness

## Key Features
- Student data input form
- Automatic status evaluation based on predefined criteria
- Visual feedback with pass/fail indicators
- Detailed breakdown of evaluation criteria

## Evaluation Criteria
- **Attendance**: Minimum 75%
- **Assignment Grade**: Minimum 70
- **Midterm Exam (UTS)**: Minimum 60
- **Final Exam (UAS)**: Minimum 60
- **Certification**: Required (boolean)
- **Administrative Completeness**: Required (boolean)
- **Final Grade**: Calculated as (Assignment×30% + UTS×30% + UAS×40%), minimum 60

## Code Style Guidelines
- Use functional components with hooks
- Follow React best practices
- Use semantic HTML elements
- Maintain consistent styling with CSS classes
- Implement proper form validation
- Use descriptive variable names in Indonesian context

## UI/UX Considerations
- Responsive design for mobile and desktop
- Clear visual feedback for pass/fail status
- Form validation with helpful error messages
- Accessible color scheme for different themes
- Indonesian language interface
