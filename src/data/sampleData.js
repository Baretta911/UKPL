// Test data for demonstration purposes

export const sampleStudents = [
  {
    nama: 'Ahmad Rizki',
    nim: '2021001',
    kehadiran: 85,
    nilaiTugas: 75,
    nilaiUTS: 70,
    nilaiUAS: 80,
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Siti Nurhaliza',
    nim: '2021002',
    kehadiran: 90,
    nilaiTugas: 88,
    nilaiUTS: 85,
    nilaiUAS: 92,
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Budi Santoso',
    nim: '2021003',
    kehadiran: 70, // Tidak memenuhi syarat kehadiran
    nilaiTugas: 80,
    nilaiUTS: 75,
    nilaiUAS: 85,
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Maya Sari',
    nim: '2021004',
    kehadiran: 80,
    nilaiTugas: 65, // Tidak memenuhi syarat nilai tugas
    nilaiUTS: 70,
    nilaiUAS: 75,
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Andi Pratama',
    nim: '2021005',
    kehadiran: 78,
    nilaiTugas: 72,
    nilaiUTS: 55, // Tidak memenuhi syarat UTS
    nilaiUAS: 68,
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Rina Wati',
    nim: '2021006',
    kehadiran: 82,
    nilaiTugas: 78,
    nilaiUTS: 75,
    nilaiUAS: 55, // Tidak memenuhi syarat UAS
    sertifikasi: true,
    kelengkapanAdmin: true
  },
  {
    nama: 'Dedi Kurniawan',
    nim: '2021007',
    kehadiran: 88,
    nilaiTugas: 85,
    nilaiUTS: 80,
    nilaiUAS: 82,
    sertifikasi: false, // Belum memiliki sertifikasi
    kelengkapanAdmin: true
  },
  {
    nama: 'Lisa Andriani',
    nim: '2021008',
    kehadiran: 92,
    nilaiTugas: 90,
    nilaiUTS: 88,
    nilaiUAS: 95,
    sertifikasi: true,
    kelengkapanAdmin: false // Administrasi belum lengkap
  }
]

/**
 * Get random sample student data
 * @returns {Object} Random student data
 */
export const getRandomStudent = () => {
  const randomIndex = Math.floor(Math.random() * sampleStudents.length)
  return sampleStudents[randomIndex]
}

/**
 * Get sample student by status (lulus/tidak lulus)
 * @param {boolean} shouldPass - Whether student should pass
 * @returns {Object} Student data
 */
export const getSampleByStatus = (shouldPass) => {
  if (shouldPass) {
    // Return students that should pass
    return sampleStudents.filter((_, index) => index <= 1)[Math.floor(Math.random() * 2)]
  } else {
    // Return students that should fail
    return sampleStudents.filter((_, index) => index > 1)[Math.floor(Math.random() * 6)]
  }
}
