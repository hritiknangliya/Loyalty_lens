import streamlit as st
import pandas as pd
import psycopg2

st.title("Automated Data Cleaning System")

uploaded_file = st.file_uploader("Upload Excel File", type=["xlsx"])

if uploaded_file:
    df = pd.read_excel(uploaded_file)
    st.write("Preview of Uploaded Data:")
    st.dataframe(df.head())

    try:
        conn = psycopg2.connect(
    host="db.lscvsrndyfyejmyjnydm.supabase.co",
    database="postgres",
    user="postgres",
    password="$Hritik1210",
    port=6543,
    sslmode="require"

)

        cursor = conn.cursor()

        # Clear old data
        cursor.execute("TRUNCATE TABLE public.raw_data;")
        conn.commit()

        # Insert new data
        for _, row in df.iterrows():
            cursor.execute(
                "INSERT INTO public.raw_data (name, age, salary, email) VALUES (%s, %s, %s, %s)",
                (row['Name'], row['Age'], row['Salary'], row['Email'])
            )
        conn.commit()

        # Call cleaning procedure
        cursor.execute("CALL public.clean_data();")
        conn.commit()

        st.success("✅ Data uploaded, cleaned and processed successfully!")

    except Exception as e:
        st.error(f"❌ Error: {e}")
