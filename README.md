# ImageProcessing1
画像処理特論Ⅰ

## Affine_Projection
3次元物体を射影カメラとアフィンカメラで投影し、投影像を比較

弱透視投影の近似が誤差になって現れる

## Epipolar_Geometry_3DMotion_Reconstruction

xx1, xx2が2つの視点における投影像、2次元画像からエピポーラ幾何の計算

カメラ行列Fから、回転R, 並進Tの計算

## Euclid_Reconstruction

内部パラメータ既知で外部パラメータ未知のカメラ画像から3次元復元（ユークリッド復元）

回転並進の組み合わせにより、4通りのカメラ運動が復元され、4通りの3次元形状が復元される（XX1, XX2, XX3, XX4）

大きさの不定性あり

## Invariance

アフィン不変量および射影不変量の計算

xx(i, : , j)によりj番目の四角形のi番目の頂点の座標データを参照可能
