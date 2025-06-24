import React from 'react'
import { getFailedReasons } from '../utils/evaluation'

const EvaluationResult = ({ result, studentData }) => {
  if (!result) return null

  return (
    <div className="card">
      <h2>Hasil Evaluasi</h2>
      <p><strong>Nama:</strong> {result.nama}</p>
      <p><strong>NIM:</strong> {result.nim}</p>
      <p><strong>Nilai Akhir:</strong> {result.nilaiAkhir}</p>
      
      <div className={`status-result ${result.statusLulus ? 'status-lulus' : 'status-tidak-lulus'}`}>
        {result.statusLulus ? '✓ LULUS' : '✗ TIDAK LULUS'}
      </div>

      <h3>Detail Kriteria:</h3>
      <ul className="criteria-list">
        <li className={result.kehadiran ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.kehadiran ? '✓' : '✗'}</span>
          Kehadiran (≥75%): {studentData.kehadiran}%
        </li>
        <li className={result.nilaiTugas ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.nilaiTugas ? '✓' : '✗'}</span>
          Nilai Tugas (≥70): {studentData.nilaiTugas}
        </li>
        <li className={result.nilaiUTS ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.nilaiUTS ? '✓' : '✗'}</span>
          Nilai UTS (≥60): {studentData.nilaiUTS}
        </li>
        <li className={result.nilaiUAS ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.nilaiUAS ? '✓' : '✗'}</span>
          Nilai UAS (≥60): {studentData.nilaiUAS}
        </li>
        <li className={result.sertifikasi ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.sertifikasi ? '✓' : '✗'}</span>
          Sertifikasi
        </li>
        <li className={result.kelengkapanAdmin ? 'criteria-passed' : 'criteria-failed'}>
          <span className="criteria-icon">{result.kelengkapanAdmin ? '✓' : '✗'}</span>
          Kelengkapan Administrasi
        </li>
      </ul>      {!result.statusLulus && (
        <div style={{marginTop: '15px', padding: '10px', backgroundColor: '#fff3cd', borderRadius: '4px', border: '1px solid #ffeaa7'}}>
          <h4 style={{color: '#856404', margin: '0 0 10px 0'}}>Alasan Tidak Lulus:</h4>
          <ul style={{margin: 0, paddingLeft: '20px', color: '#856404'}}>
            {getFailedReasons(result).map((reason, index) => (
              <li key={index}>{reason}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export default EvaluationResult
