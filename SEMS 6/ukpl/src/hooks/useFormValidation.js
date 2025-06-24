// Form validation hooks and utilities

import { useState, useEffect } from 'react'

/**
 * Custom hook for form validation
 * @param {Object} initialData - Initial form data
 * @param {Object} validationRules - Validation rules
 * @returns {Object} Validation state and functions
 */
export const useFormValidation = (initialData, validationRules) => {
  const [errors, setErrors] = useState({})
  const [isValid, setIsValid] = useState(false)

  const validateField = (name, value) => {
    const rules = validationRules[name]
    if (!rules) return null

    if (rules.required && (!value || value === 0)) {
      return `${name} harus diisi`
    }

    if (rules.min !== undefined && value < rules.min) {
      return `${name} minimal ${rules.min}`
    }

    if (rules.max !== undefined && value > rules.max) {
      return `${name} maksimal ${rules.max}`
    }

    return null
  }

  const validateForm = (data) => {
    const newErrors = {}
    let formIsValid = true

    Object.keys(validationRules).forEach(field => {
      const error = validateField(field, data[field])
      if (error) {
        newErrors[field] = error
        formIsValid = false
      }
    })

    setErrors(newErrors)
    setIsValid(formIsValid)
    return formIsValid
  }

  const clearErrors = () => {
    setErrors({})
    setIsValid(false)
  }

  return {
    errors,
    isValid,
    validateField,
    validateForm,
    clearErrors
  }
}

/**
 * Format number to Indonesian locale
 * @param {number} num - Number to format
 * @returns {string} Formatted number
 */
export const formatNumber = (num) => {
  return new Intl.NumberFormat('id-ID', {
    minimumFractionDigits: 0,
    maximumFractionDigits: 2
  }).format(num)
}

/**
 * Get grade letter based on numeric value
 * @param {number} grade - Numeric grade
 * @returns {string} Grade letter
 */
export const getGradeLetter = (grade) => {
  if (grade >= 80) return 'A'
  if (grade >= 70) return 'B'
  if (grade >= 60) return 'C'
  if (grade >= 50) return 'D'
  return 'E'
}
