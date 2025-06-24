import { useState } from 'react'
import StudentForm from './components/StudentForm'
import EvaluationResult from './components/EvaluationResult'
import { evaluateStudentStatus, getInitialStudentData } from './utils/evaluation'
import './App.css'

function App() {
  const [studentData, setStudentData] = useState(getInitialStudentData())
  const [evaluationResult, setEvaluationResult] = useState(null)

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target
    setStudentData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : type === 'number' ? Number(value) : value
    }))
  }

  const evaluateStudent = () => {
    const result = evaluateStudentStatus(studentData)
    setEvaluationResult(result)
  }
  const resetForm = () => {
    setStudentData(getInitialStudentData())
    setEvaluationResult(null)
  }

  const loadSampleData = (sampleData) => {
    setStudentData(sampleData)
    setEvaluationResult(null)
  }
  return (
    <div className="container">
      <h1>Sistem Evaluasi Status Mahasiswa</h1>
        <StudentForm 
        studentData={studentData}
        onInputChange={handleInputChange}
        onEvaluate={evaluateStudent}
        onReset={resetForm}
        onLoadSample={loadSampleData}
      />

      <EvaluationResult 
        result={evaluationResult}
        studentData={studentData}
      />
    </div>
  )
}

export default App
