import random
import base64
import hashlib
from ecdsa import SECP256k1
from math import gcd
import random


def coprime_integers(n, limit):
        return [i for i in range(1, limit + 1) if gcd(n, i) == 1]

def get_function(E):  
    n=E.order
    nlist=coprime_integers(n, 10000)
    r=random.choice(nlist)
    return r

    
##### From(A)에서 사용하는 함수
def generate_keys(E):
    G = E.generator
    n = E.order
    private_key = random.randint(1, n-1) #d
    public_key = private_key * G #Q
    return private_key, public_key

# ElGamal encryption
def encrypt(E, public_key, message_point):
    G = E.generator
    n = E.order
    k = random.randint(1, n-1)
    R = k * G
    S = k * public_key
    C = message_point + S
    return R, C

# 서명용 키(sigKey) 생성
def sigKeygen(E, EIG):
    G = E.generator
    sigsk=random.randrange(0, E.order)
    sigpk=sigsk*G
    EI = sigsk*EIG
    return sigsk, sigpk, EI

import base64

def base64url_encode(plain_text):
    # 평문을 바이트 형식으로 변환
    byte_data = plain_text.encode('utf-8')
    
    # Base64로 인코딩 후 URL-safe 형식으로 변환
    base64_encoded = base64.urlsafe_b64encode(byte_data)
    
    # 패딩 문자인 '=' 제거
    return base64_encoded.rstrip(b'=').decode('utf-8')

#### EHT 생성
def EHTgen(Iss, Sub, Aud, Exp, Nbf, Iat, value, P_A, P_B, sigsk, EIG, Q):
    text=Iss+'.'+Sub+'.'+Aud+'.'+Exp+'.'+Nbf+'.'+Iat
    encodetext=base64url_encode(text)
    encA=encrypt(Q, value*P_A)
    encB=encrypt(Q, value*P_B)
    sig=Digi(sigsk, encodetext)
    eht=encodetext+'.'+str(encA)+'.'+str(encB)+'.'+str(sig)
    return eht

#### To(B)에서 사용하는 함수
# 분리시키는 함수
def split_text_by_period(text):
    # '.'을 기준으로 텍스트를 나누고 리스트로 반환
    return text.split('.')
    
def base64url_decode(encoded_text):
    # Base64Url 인코딩된 문자열의 패딩을 복원 (4의 배수로 맞추기)
    padding_needed = 4 - (len(encoded_text) % 4)
    if padding_needed:
        encoded_text += '=' * padding_needed

    # Base64Url 디코딩
    byte_data = base64.urlsafe_b64decode(encoded_text)
    
    # UTF-8로 디코딩하여 평문으로 변환
    return byte_data.decode('utf-8')

#### EHT 검증하는 함수
def EHTverify(token, r, s, EI):
    # 텍스트를 분리
    parts = split_text_by_period(token)

    # 서명 검증
    encodetext = parts[0]
    verification_result = Verify(r, s, EI, encodetext)

    if verification_result == "Accept":
        # 가운데 두 개의 텍스트 반환
        return parts[1], parts[2]
    else:
        return "Signature verification failed"

def coprime_integers(n, limit):
        return [i for i in range(1, limit + 1) if gcd(n, i) == 1]


#### EHDSA generating
# Digi 함수 구현
def Digi(E, EIG, sigsk, text):
    import hashlib
    R = int(E.order)
    k = random.randrange(0, E.order)
    x = k*EIG
    r = x % R

    txt = text.encode('utf-8')
    # 해시 계산
    md5 = hashlib.new('md5')
    md5.update(txt)

    # 해시를 정수로 변환
    z = int(md5.hexdigest(), 16)
    
    # e 계산
    e = z % R
    
    # y 계산
    num = (e + sigsk * r) % R  # mod R
    y = (num * pow(k, R-2, R))
    
    # s 계산
    s = y % R
    
    return r, s


def Verify(E, EIG, r, s, EI, text):
    import hashlib
    # 텍스트를 utf-8로 인코딩
    R = int(E.order)
    txt = text.encode('utf-8')
    # 해시 계산
    md5 = hashlib.new('md5')
    md5.update(txt)
    # 해시를 정수로 변환
    z = int(md5.hexdigest(), 16)

    # e 계산
    e = z % R
    
    # s의 역원 계산
    w = pow(int(s), R-2, R)
    
    # u1과 u2 계산
    u1 = int(e * w)%R
    u2 = int(r * w)%R
    
    # EIGX 계산
    rs = u1* EIG + u2 * EI
    EIGX = rs % R
    
    # 서명 검
    if EIGX == r:
        return "Accept"
    else:
        return "Reject"
    
