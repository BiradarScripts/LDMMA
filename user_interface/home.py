import streamlit as st
import numpy as np
import random

# Initialize session state for matrices if not already initialized
if 'matrix1' not in st.session_state:
    st.session_state.matrix1 = np.zeros((4, 4), dtype=int)
if 'matrix2' not in st.session_state:
    st.session_state.matrix2 = np.zeros((4, 4), dtype=int)

# Function to perform matrix multiplication
def multiply_matrices(matrix1, matrix2):
    return np.dot(matrix1, matrix2)

# Function to generate a random 4x4 matrix
def generate_random_matrix():
    return np.random.randint(-100, 101, size=(4, 4))

# Streamlit UI setup
st.set_page_config(page_title="Matrix Multiplication", page_icon="🔢", layout="centered")

# Background CSS animation for a dynamic effect
st.markdown(
    """
    <style>
    .background {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: -1;
        background: #e0f7fa;
        overflow: hidden;
    }
    .circle {
        position: absolute;
        border-radius: 50%;
        background: rgba(0, 150, 136, 0.1);
        animation: float 10s linear infinite;
    }
    @keyframes float {
        0% { transform: translateY(0px) translateX(0px); }
        50% { transform: translateY(-20px) translateX(20px); }
        100% { transform: translateY(0px) translateX(0px); }
    }
    </style>
    <div class="background">
        <div class="circle" style="width: 200px; height: 200px; top: 20%; left: 10%;"></div>
        <div class="circle" style="width: 100px; height: 100px; top: 70%; left: 80%;"></div>
        <div class="circle" style="width: 150px; height: 150px; top: 40%; left: 60%;"></div>
        <div class="circle" style="width: 120px; height: 120px; top: 80%; left: 20%;"></div>
    </div>
    """, unsafe_allow_html=True
)

# Title and description
st.title("🔢 4x4 Matrix Multiplication")
st.write("Enter the elements of two 4x4 matrices, and this tool will calculate their product.")

st.markdown("---")

# Matrix 1 input
st.subheader("Matrix 1 (A)")
matrix1 = []
for i in range(4):
    row = st.columns(4)
    matrix1.append([row[j].number_input(f"A[{i+1}][{j+1}]", key=f"m1_{i}_{j}", 
                                         min_value=-100, max_value=100, 
                                         value=int(st.session_state.matrix1[i][j]), 
                                         step=1, format="%d", label_visibility="collapsed") 
                    for j in range(4)])

st.markdown("---")  # Separation line between Matrix 1 and Matrix 2

# Matrix 2 input
st.subheader("Matrix 2 (B)")
matrix2 = []
for i in range(4):
    row = st.columns(4)
    matrix2.append([row[j].number_input(f"B[{i+1}][{j+1}]", key=f"m2_{i}_{j}", 
                                         min_value=-100, max_value=100, 
                                         value=int(st.session_state.matrix2[i][j]), 
                                         step=1, format="%d", label_visibility="collapsed") 
                    for j in range(4)])

# Convert lists to numpy arrays for matrix multiplication
matrix1_np = np.array(matrix1)
matrix2_np = np.array(matrix2)

# Buttons for additional functionalities
btn_col1, btn_col2, btn_col3 = st.columns(3)

# Copy button to transfer values from Matrix 1 to Matrix 2
with btn_col1:
    if st.button("Copy Matrix A to Matrix B"):
        st.session_state.matrix2 = matrix1_np

# Random button to fill both matrices with random values
with btn_col2:
    if st.button("Randomize Matrices"):
        st.session_state.matrix1 = generate_random_matrix()
        st.session_state.matrix2 = generate_random_matrix()

# Calculate button to compute the product
with btn_col3:
    if st.button("Calculate Product"):
        try:
            result = multiply_matrices(matrix1_np, matrix2_np)
            st.success("Matrix multiplication successful!")
            
            st.subheader("Resultant Matrix")
            # Display the resulting matrix in a styled grid
            for i in range(4):
                result_cols = st.columns(4)
                for j in range(4):
                    result_cols[j].write(f"**{result[i][j]:d}**")
                    
        except Exception as e:
            st.error(f"Error: {e}")

# Footer
st.markdown("---")
st.markdown("Developed with ❤️ using Streamlit", unsafe_allow_html=True)
